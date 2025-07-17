import mongoose from "mongoose";
import express from "express";
import bodyParser from "body-parser";
import cors from "cors";
import { setupSwagger } from "./swagger.js";


import { UserRoutes, PostRoutes } from "./routes/index.js";
import {
  MONGO_CONNECTION_STRING,
  PORT,
} from "./env.js";

await mongoose.connect(MONGO_CONNECTION_STRING);
const app = express();
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.json({ limit: "100mb" }));

app.use(UserRoutes);
app.use(PostRoutes);

setupSwagger(app);
app.get("/ready", (req, res) => {
  res.status(200).send("OK");
});

app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});
