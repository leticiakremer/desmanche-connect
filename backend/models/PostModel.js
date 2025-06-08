import { Schema, model } from "mongoose";

const postSchema = new Schema({
  title: String,
  description: String,
  category: String,
  active: Boolean,
  images: [String],
  coverImage: Number,
  price: Number,
});

postSchema.virtual("id").get(function () {
  return this._id.toString();
});

postSchema.set("toJSON", {
  virtuals: true,
  versionKey: false,
  transform: function (doc, ret) {
    delete ret._id;
  },
});

export default model("Post", postSchema);
