import mongoose from "mongoose";
import express from "express";
import bodyParser from "body-parser";
import { validationResult } from "express-validator";
import {
  createPostValidationSchema,
  deletePostValidationSchema,
} from "./validations/postValidations.js";
import cors from "cors";

import PostSchema from "./schemas/PostSchema.js";

await mongoose.connect(
  "mongodb+srv://leticiakremer24:kHEIdImPi76CPpsu@clusterpds.ofiwoyd.mongodb.net/pds?retryWrites=true&w=majority&appName=ClusterPDS"
);

const PostModel = mongoose.model("Post", PostSchema);

const app = express();
app.use(
  cors({
    origin: "*",
    methods: ["GET", "POST", "DELETE"],
    allowedHeaders: ["Content-Type", "Authorization"],
  })
);

app.use(bodyParser.json());

app.post("/v1/posts", createPostValidationSchema, async (req, res) => {
  let result = validationResult(req);
  if (!result.isEmpty()) {
    return res.status(400).json({
      messages: ["Failed to create post due to validation errors"],
      data: null,
      errors: result.array(),
    });
  }

  const { title, description, category, active, images, coverImage, price } =
    req.body;

  let post = new PostModel({
    title,
    description,
    category,
    active,
    images,
    coverImage,
    price,
  });
  var createdDocument = await post.save();
  //TODO: Criar a postagem no instagram e facebook

  res.status(200).json({
    messages: ["Post created successfully"],
    data: post,
    errors: null,
  });
});

app.get("/v1/posts", async (req, res) => {
  const { search, take, skip } = req.query;
  const searchString = search ? search.toString() : "";
  const posts = await PostModel.find({
    $or: [
      { title: { $regex: searchString, $options: "i" } },
      { description: { $regex: searchString, $options: "i" } },
      //indexação seria melhor que regex, mas não é o foco do projeto
    ],
  })
    .sort({ createdAt: -1 })
    .limit(take ?? 10)
    .skip(skip ?? 0);

  const totalCount = await PostModel.countDocuments({
    $or: [
      { title: { $regex: searchString, $options: "i" } },
      { description: { $regex: searchString, $options: "i" } },
    ],
  });

  let response = {
    data: {
      items: posts,
      total: totalCount,
    },
    messages: ["Posts retrieved successfully"],
  };

  res.status(200).json(response);
});

app.get("/v1/posts/:id", async (req, res) => {
  const { id } = req.params;
  var post = await PostModel.findById(id);
  if (post === null) {
    return res.status(404).json({
      messages: ["Post not found"],
      data: null,
      errors: null,
    });
  }

  res.status(200).json({
    messages: null,
    data: post,
    errors: null,
  });
});

app.delete("/v1/posts/:id", deletePostValidationSchema, async (req, res) => {
  let result = validationResult(req);
  if (!result.isEmpty()) {
    return res.status(400).json({
      messages: ["Failed to delete post due to validation errors"],
      data: null,
      errors: result.array(),
    });
  }

  const { id } = req.params;
  await PostModel.deleteOne({ _id: id });
  res.status(200).json({
    messages: ["Post deleted successfully"],
    data: null,
    errors: null,
  });
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
