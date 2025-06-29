import express from "express";
import jwt from "jsonwebtoken";
import { UserModel } from "../models/index.js";
import { UserValidations } from "../validations/index.js";
import { HandleValidation, Authorize } from "../middlewares/index.js";

const router = express.Router();

/**
 * @swagger
 * /v1/users:
 *   get:
 *     summary: Get a list of users
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search keyword for name or username
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *         description: Number of records to return
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *         description: Number of records to skip
 *     responses:
 *       200:
 *         description: List of users
 */
router.get("/v1/users", Authorize, async (req, res) => {
  try {
    const { search, take, skip } = req.query;
    const searchString = search ? search.toString() : "";
    const takeNumber = Number.parseInt(take?.toString() ?? "10");
    const skipNumber = Number.parseInt(skip?.toString() ?? "0");

    const query = {
      $or: [
        { name: { $regex: searchString, $options: "i" } },
        { username: { $regex: searchString, $options: "i" } },
      ],
    };

    const users = await UserModel.find(query, { password: 0 })
      .sort({ createdAt: -1 })
      .limit(takeNumber)
      .skip(skipNumber);

    const totalCount = await UserModel.countDocuments(query);

    return res.status(200).json({
      messages: ["Users retrieved successfully"],
      data: {
        items: users,
        totalCount,
      },
      errors: null,
    });
  } catch (err) {
    return res.status(500).json({
      messages: ["Failed to retrieve users"],
      data: null,
      errors: [err.message],
    });
  }
});

/**
 * @swagger
 * /v1/users/{id}:
 *   get:
 *     summary: Get user by ID
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *     responses:
 *       200:
 *         description: User found
 *       404:
 *         description: User not found
 */
router.get("/v1/users/:id", Authorize, async (req, res) => {
  const { id } = req.params;

  try {
    const user = await UserModel.findById(id, { password: 0 });

    if (!user) {
      return res.status(404).json({
        messages: ["User not found"],
        data: null,
        errors: null,
      });
    }

    return res.status(200).json({
      messages: ["User retrieved successfully"],
      data: user,
      errors: null,
    });
  } catch (err) {
    return res.status(500).json({
      messages: ["Failed to retrieve user"],
      data: null,
      errors: [err.message],
    });
  }
});

/**
 * @swagger
 * /v1/users/register:
 *   post:
 *     summary: Register a new user
 *     tags: [Users]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - name
 *               - username
 *               - password
 *             properties:
 *               name:
 *                 type: string
 *               username:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       201:
 *         description: User registered successfully
 *       400:
 *         description: User already exists
 */
router.post(
  "/v1/users/register",
  Authorize,
  UserValidations.registerUserValidationSchema,
  HandleValidation,
  async (req, res) => {
    const { name, username, password } = req.body;

    try {
      const userExists = await UserModel.findOne({ username });
      if (userExists) {
        return res.status(400).json({
          messages: ["User already exists"],
          data: null,
          errors: null,
        });
      }

      const user = await UserModel.create({ name, username, password });
      return res.status(201).json({
        messages: ["User registered successfully"],
        data: user,
        errors: null,
      });
    } catch (err) {
      return res.status(500).json({
        messages: ["Failed to register user"],
        data: null,
        errors: [err.message],
      });
    }
  }
);

/**
 * @swagger
 * /v1/users/login:
 *   post:
 *     summary: Authenticate user and return JWT tokens
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - username
 *               - password
 *             properties:
 *               username:
 *                 type: string
 *               password:
 *                 type: string
 *     responses:
 *       200:
 *         description: Login successful
 *       400:
 *         description: Invalid credentials
 */
router.post(
  "/v1/users/login",
  UserValidations.loginUserValidationSchema,
  HandleValidation,
  async (req, res) => {
    const { username, password } = req.body;

    try {
      const user = await UserModel.findOne({ username });
      if (!user || !(await user.matchPassword(password))) {
        return res.status(400).json({
          messages: ["Invalid credentials"],
          data: null,
          errors: null,
        });
      }

      const accessToken = jwt.sign(
        { id: user._id, username: user.username, name: user.name },
        process.env.JWT_SECRET,
        { expiresIn: "1d" }
      );

      const refreshToken = jwt.sign(
        { id: user._id },
        process.env.JWT_REFRESH_SECRET,
        { expiresIn: "7d" }
      );

      const { exp: accessExp } = jwt.decode(accessToken);
      const { exp: refreshExp } = jwt.decode(refreshToken);

      return res.status(200).json({
        messages: ["Login successful"],
        data: {
          accessToken,
          refreshToken,
          expiresAt: accessExp * 1000,
          refreshTokenExpiresAt: refreshExp * 1000,
        },
        errors: null,
      });
    } catch (err) {
      return res.status(500).json({
        messages: ["Failed to log in"],
        data: null,
        errors: [err.message],
      });
    }
  }
);

/**
 * @swagger
 * /v1/users/refresh:
 *   post:
 *     summary: Refresh access token using a refresh token
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - refreshToken
 *             properties:
 *               refreshToken:
 *                 type: string
 *     responses:
 *       200:
 *         description: Token refreshed successfully
 *       400:
 *         description: Refresh token is required
 *       403:
 *         description: Invalid or expired refresh token
 */
router.post("/v1/users/refresh", async (req, res) => {
  const { refreshToken } = req.body;

  if (!refreshToken) {
    return res.status(400).json({
      messages: ["Refresh token is required"],
      data: null,
      errors: null,
    });
  }

  try {
    const decoded = jwt.verify(refreshToken, process.env.JWT_REFRESH_SECRET);
    const accessToken = jwt.sign({ id: decoded.id }, process.env.JWT_SECRET, {
      expiresIn: "1d",
    });

    const { exp } = jwt.decode(accessToken);

    return res.status(200).json({
      messages: ["Token refreshed successfully"],
      data: {
        accessToken,
        expiresAt: exp * 1000,
      },
      errors: null,
    });
  } catch (err) {
    return res.status(403).json({
      messages: ["Invalid or expired refresh token"],
      data: null,
      errors: [err.message],
    });
  }
});

export default router;
