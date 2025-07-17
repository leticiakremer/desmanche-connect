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

// Conecta ao MongoDB
await mongoose.connect(MONGO_CONNECTION_STRING);

// Inicializa o app
const app = express();

app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.json({ limit: "100mb" }));

// Rotas
app.use(UserRoutes);
app.use(PostRoutes);

setupSwagger(app);

// Inicializa o servidor
app.listen(PORT, () => {
  console.log(`🚀 Server is running on port ${PORT}`);
});
