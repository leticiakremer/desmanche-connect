import express from "express";
import jwt from "jsonwebtoken";
import { UserModel } from "../models/index.js";

const router = express.Router();

//TODO: Validation
router.post("/v1/users/register", async (req, res) => {
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
});

//TODO: Validation
router.post("/v1/users/login", async (req, res) => {
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

    // Gera o access token (curta duração)
    const accessToken = jwt.sign(
      { id: user._id, username: user.username, name: user.name },
      process.env.JWT_SECRET,
      { expiresIn: "1d" }
    );

    // Gera o refresh token (longa duração)
    const refreshToken = jwt.sign(
      { id: user._id },
      process.env.JWT_REFRESH_SECRET,
      { expiresIn: "7d" }
    );

    // Decodifica o token para obter o timestamp de expiração
    const { exp } = jwt.decode(accessToken);

    return res.status(200).json({
      messages: ["Login successful"],
      data: {
        token: accessToken,
        refreshToken,
        expiresAt: exp * 1000, // milissegundos
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
});

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
        token: accessToken,
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
