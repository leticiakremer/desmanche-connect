import 'package:image_picker/image_picker.dart';

class CreatePostModel {
  final String title;
  final String description;
  final String category;
  final bool active;
  final List<XFile> images;
  final int coverImage;
  final double price;
  final List<String>? existingImages;

  CreatePostModel(
      {required this.title,
      required this.description,
      required this.category,
      required this.active,
      required this.images,
      required this.coverImage,
      required this.price,
      this.existingImages});
}
