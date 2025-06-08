class PaginatedDataModel<T> {
  List<T> items;
  int totalCount;

  PaginatedDataModel({
    required this.items,
    required this.totalCount,
  });

  factory PaginatedDataModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return PaginatedDataModel<T>(
      items: (json['items'] as List)
          .map((item) => fromJsonT(item as Map<String, dynamic>))
          .toList(),
      totalCount: json['totalCount'] as int,
    );
  }
}
