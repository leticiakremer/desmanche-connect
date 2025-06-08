class PostModel {
  final String? id;
  final String title;
  final String description;
  final String category;
  final bool active;
  final List<String> images;
  final int coverImage;
  final double price;

  PostModel(
      {this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.active,
      required this.images,
      required this.coverImage,
      required this.price});

  factory PostModel.fromJson(Map<String, dynamic> json) {
    return PostModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      category: json['category'],
      active: json['active'] as bool,
      images: List<String>.from(json['images']),
      coverImage: json['coverImage'] as int,
      price: json['price'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
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
