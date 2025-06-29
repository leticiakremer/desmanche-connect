import express from "express";
import { PostValidations } from "../validations/index.js";
import { PostModel, ImageModel } from "../models/index.js";
import { HandleValidation, Upload, Authorize } from "../middlewares/index.js";

const router = express.Router();

/**
 * @swagger
 * /v1/posts:
 *   post:
 *     summary: Create a new post
 *     tags: [Posts]
 *     security:
 *       - bearerAuth: []
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               images:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *               data:
 *                 type: string
 *                 description: >
 *                   JSON string with post data, example:
 *                   { "title": "Post test", "description": "teste", "category": "Carro", "active": true, "coverImage": 0, "price": null }
 *     responses:
 *       201:
 *         description: Post created successfully
 *       400:
 *         description: No image was uploaded
 *       500:
 *         description: Failed to create post
 */
router.post(
  "/v1/posts",
  Authorize,
  Upload.array("images"),
  PostValidations.createPostValidationSchema,
  HandleValidation,
  async (req, res) => {
    try {
      const { title, description, category, active, price, coverImage } =
        JSON.parse(req.body.data);
      const files = req.files;

      if (!files || files.length === 0) {
        return res
          .status(400)
          .json({ messages: ["No image was uploaded"], data: null });
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
        messages: ["Failed to create post"],
        data: null,
        errors: [error.message],
      });
    }
  }
);

/**
 * @swagger
 * /v1/posts/{id}:
 *   put:
 *     summary: Edit a post by ID
 *     tags: [Posts]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     requestBody:
 *       required: true
 *       content:
 *         multipart/form-data:
 *           schema:
 *             type: object
 *             properties:
 *               images:
 *                 type: array
 *                 items:
 *                   type: string
 *                   format: binary
 *               data:
 *                 type: string
 *                 description: >
 *                   JSON string with post data, example:
 *                   { "title": "Updated title", "description": "Updated desc", "category": "Moto", "active": true, "coverImage": 1, "price": 500 }
 *     responses:
 *       200:
 *         description: Post updated successfully
 *       404:
 *         description: Post not found
 *       500:
 *         description: Failed to update post
 */
router.put(
  "/v1/posts/:id",
  Authorize,
  Upload.array("images"),
  PostValidations.updatePostValidationSchema,
  HandleValidation,
  async (req, res) => {
    const { id } = req.params;

    try {
      const { title, description, category, active, price, coverImage } =
        JSON.parse(req.body.data);
      const files = req.files;

      const post = await PostModel.findById(id);
      if (!post) {
        return res.status(404).json({
          messages: ["Post not found"],
          data: null,
          errors: null,
        });
      }

      // Remove imagens antigas
      await ImageModel.deleteMany({ _id: { $in: post.images } });

      // Salva novas imagens
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

      // Atualiza os campos
      post.title = title;
      post.description = description;
      post.category = category;
      post.active = active;
      post.price = price;
      post.coverImage = coverImage;
      post.images = savedImages.map((img) => img._id);

      await post.save();

      res.status(200).json({
        messages: ["Post updated successfully"],
        data: post,
        errors: null,
      });
    } catch (error) {
      console.error(error);
      res.status(500).json({
        messages: ["Failed to update post"],
        data: null,
        errors: [error.message],
      });
    }
  }
);

/**
 * @swagger
 * /v1/posts:
 *   get:
 *     summary: Retrieve a list of posts with optional search
 *     tags: [Posts]
 *     parameters:
 *       - in: query
 *         name: search
 *         schema:
 *           type: string
 *         description: Search keyword
 *       - in: query
 *         name: take
 *         schema:
 *           type: integer
 *         description: Number of items to return
 *       - in: query
 *         name: skip
 *         schema:
 *           type: integer
 *         description: Number of items to skip
 *     responses:
 *       200:
 *         description: List of posts
 */
router.get("/v1/posts", async (req, res) => {
  const { search, take, skip } = req.query;
  const searchString = search ? search.toString() : "";
  const takeNumber = Number.parseInt(take?.toString() ?? "10");
  const skipNumber = Number.parseInt(skip?.toString() ?? "0");

  const posts = await PostModel.find({
    $or: [
      { title: { $regex: searchString, $options: "i" } },
      { description: { $regex: searchString, $options: "i" } },
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

  res.status(200).json({
    data: {
      items: posts,
      totalCount,
    },
    messages: ["Posts retrieved successfully"],
  });
});

/**
 * @swagger
 * /v1/posts/images/{id}:
 *   get:
 *     summary: Get image by ID
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Image ID
 *     responses:
 *       200:
 *         description: Image file
 *       404:
 *         description: Image not found
 */
router.get("/v1/posts/images/:id", async (req, res) => {
  try {
    const image = await ImageModel.findById(req.params.id);
    if (!image) {
      return res.status(404).send("Image not found");
    }

    res.set("Content-Type", image.mimetype);
    res.send(image.data);
  } catch (error) {
    console.error(error);
    res.status(500).send("Failed to fetch image");
  }
});

/**
 * @swagger
 * /v1/posts/{id}:
 *   get:
 *     summary: Get post by ID
 *     tags: [Posts]
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     responses:
 *       200:
 *         description: Post found
 *       404:
 *         description: Post not found
 */
router.get("/v1/posts/:id", async (req, res) => {
  const { id } = req.params;
  const post = await PostModel.findById(id);
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

/**
 * @swagger
 * /v1/posts/{id}:
 *   delete:
 *     summary: Delete a post by ID
 *     tags: [Posts]
 *     security:
 *       - bearerAuth: []
 *     parameters:
 *       - in: path
 *         name: id
 *         required: true
 *         schema:
 *           type: string
 *         description: Post ID
 *     responses:
 *       200:
 *         description: Post deleted successfully
 */
router.delete(
  "/v1/posts/:id",
  Authorize,
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
