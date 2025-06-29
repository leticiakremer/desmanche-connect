import express from "express";
import { validationResult } from "express-validator";
import { PostValidations } from "../validations/index.js";
import { PostModel, ImageModel } from "../models/index.js";
import { HandleValidation, Upload } from "../middlewares/index.js";

const router = express.Router();

router.post(
  "/v1/posts",
  Upload.array("images"),
  PostValidations.createPostValidationSchema,
  HandleValidation,
  async (req, res) => {
    try {
      const { title, description, category, active, price, coverImage } = JSON.parse(req.body.data);
      const files = req.files;

      if (!files || files.length === 0) {
        return res.status(400).json({ messages: ["Nenhuma imagem foi enviada"], data: null });
      }

      const savedImages = await Promise.all(
        files.map((file) => {
          const image = new ImageModel({
            filename: file.originalname,
            mimetype: file.mimetype,
            data: file.buffer,
          });
          return image.save();
        })
      );

      const post = new PostModel({
        title,
        description,
        category,
        active,
        images: savedImages.map((img) => img._id),
        coverImage: coverImage,
        price,
      });

      await post.save();

      res.status(201).json({
        messages: ["Post created successfully"],
        data: post,
        errors: null,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        messages: ["Erro ao criar post"],
        data: null,
        errors: [error.message],
      });
    }
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
      totalCount,
    },
    messages: ["Posts retrieved successfully"],
  };

  res.status(200).json(response);
});


router.get("/v1/posts/images/:id", async (req, res) => {
  try {
    const image = await ImageModel.findById(req.params.id);
    if (!image) {
      return res.status(404).send("Imagem não encontrada");
    }

    res.set("Content-Type", image.mimetype);
    res.send(image.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Erro ao buscar imagem");
  }
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
  HandleValidation,
  async (req, res) => {
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
