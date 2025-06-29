import jwt from "jsonwebtoken";
import { JWT_SECRET } from "../env.js";

export default function Authorize(req, res, next) {
  const authHeader = req.headers.authorization;

  if (!authHeader || !authHeader.startsWith("Bearer ")) {
    return res.status(401).json({
      messages: ["Authentication token is missing or invalid"],
      data: null,
      errors: null,
    });
  }

  const token = authHeader.split(" ")[1];

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.user = decoded;
    next();
  } catch (error) {
    return res.status(401).json({
      messages: ["Invalid or expired token"],
      data: null,
      errors: [error.message],
    });
  }
}
