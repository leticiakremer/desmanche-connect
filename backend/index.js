import mongoose from "mongoose";
import express from "express";
import bodyParser from "body-parser";
import { validationResult } from "express-validator";
import {
  createPostValidationSchema,
  searchPostsValidationSchema,
  deletePostValidationSchema,
} from "./validations/postValidations.js";
import cors from "cors";

await mongoose.connect(
  "mongodb+srv://leticiakremer24:kHEIdImPi76CPpsu@clusterpds.ofiwoyd.mongodb.net/pds?retryWrites=true&w=majority&appName=ClusterPDS"
);

const Schema = mongoose.Schema;
const ObjectId = Schema.ObjectId;

const PostSchema = new Schema({
  id: ObjectId,
  title: String,
  description: String,
  category: String,
  active: Boolean,
  images: [String],
  coverImage: Number,
  price: Number,
});

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
    return res.status(400).json({ messages: ["Failed to create post due to validation errors"], data: null, errors: result.array() });
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
  await post.save();

  //TODO: Criar a postagem no instagram e facebook

  res.status(200).json({ messages: ["Post created successfully"], data: post, errors: null });
});

app.get("/v1/posts", searchPostsValidationSchema, async (req, res) => {
  let result = validationResult(req);
  if (!result.isEmpty()) {
    return res.status(400).json({ errors: result.array() });
  }

  const { search, take, skip } = req.query;
  const posts = await PostModel.find({
    $or: [
      { title: { $regex: search, $options: "i" } },
      { description: { $regex: search, $options: "i" } },
      //indexação seria melhor que regex, mas não é o foco do projeto
    ],
  })
    .sort({ createdAt: -1 })
    .limit(take ?? 10)
    .skip(skip ?? 0);

  const totalCount = await PostModel.countDocuments({
    $or: [
      { title: { $regex: search, $options: "i" } },
      { description: { $regex: search, $options: "i" } },
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

app.delete("/v1/posts/:id", deletePostValidationSchema, async (req, res) => {
  let result = validationResult(req);
  if (!result.isEmpty()) {
    return res.status(400).json({ errors: result.array() });
  }

  const { id } = req.params;
  await PostModel.deleteOne({ _id: id });
  res.status(200).json({ messages: ["Post deleted successfully"], data: null, errors: null });
});

app.listen(3000, () => {
  console.log("Server is running on port 3000");
});
