class PostModel {
  final String title;
  final String description;
  final String category;
  final bool active;
  final List<String> images;
  final int coverImage;
  final double price;

  PostModel(
      {required this.title,
      required this.description,
      required this.category,
      required this.active,
      required this.images,
      required this.coverImage,
      required this.price});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      title: json['title'],
      description: json['description'],
      category: json['category'],
      active: json['active'],
      images: List<String>.from(json['images']),
      coverImage: json['coverImage'],
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'active': active,
      'images': images,
      'coverImage': coverImage,
      'price': price,
    };
  }
}