import express from "express";
import jwt from "jsonwebtoken";
import { UserModel } from "../models/index.js";
import { UserValidations } from "../validations/index.js";
import { HandleValidation } from "../middlewares/index.js";

const router = express.Router();

router.post(
  "/v1/users/register",
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

router.post(
  "/v1/users/login",
  UserValidations.loginUserValidationSchema,
  HandleValidation,
  async (req, res) => {
    const { username, password } = req.body;

    try {
      const user = await UserModel.findOne({ username });
      if (!user || !(await user.matchPassword(password))) {
        return res.status(401).json({
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
