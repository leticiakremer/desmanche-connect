class ApiResponseModel<T> {
  final List<String>? messages;
  final T? data;
  final Map<String, dynamic>? errors;

  ApiResponseModel({
    this.messages,
    this.data,
    this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json, T Function(Map<String, dynamic>) fromJsonT) {
    return ApiResponseModel(
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}
