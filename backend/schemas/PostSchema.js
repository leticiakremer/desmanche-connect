import mongoose from "mongoose";

const Schema = mongoose.Schema;
const PostSchema = new Schema({
  title: String,
  description: String,
  category: String,
  active: Boolean,
  images: [String],
  coverImage: Number,
  price: Number,
});

PostSchema.virtual("id").get(function () {
  return this._id.toString();
});

PostSchema.set("toJSON", {
  virtuals: true,
  versionKey: false,
  transform: function (doc, ret) {
    delete ret._id;
  },
});

export default PostSchema;
