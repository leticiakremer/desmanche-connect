import express from "express";
import { validationResult } from "express-validator";
import { PostValidations } from "../validations/index.js";
import { PostModel } from "../models/index.js";

const router = express.Router();

router.post(
  "/v1/posts",
  PostValidations.createPostValidationSchema,
  async (req, res) => {
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
    await post.save();
    //TODO: Criar a postagem no instagram e facebook

    res.status(200).json({
      messages: ["Post created successfully"],
      data: post,
      errors: null,
    });
  }
);

router.get("/v1/posts", async (req, res) => {
  const { search, take, skip } = req.query;
  const searchString = search ? search.toString() : "";
  const takeNumber = Number.parseInt(take?.toString() ?? "10");
  const skipNumber = Number.parseInt(skip?.toString() ?? "0");
  const posts = await PostModel.find({
    $or: [
      { title: { $regex: searchString, $options: "i" } },
      { description: { $regex: searchString, $options: "i" } },
      //indexação seria melhor que regex, mas não é o foco do projeto
    ],
  })
    .sort({ createdAt: -1 })
    .limit(takeNumber)
    .skip(skipNumber);

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

router.get("/v1/posts/:id", async (req, res) => {
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

router.delete(
  "/v1/posts/:id",
  PostValidations.deletePostValidationSchema,
  async (req, res) => {
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
  }
);

export default router;
