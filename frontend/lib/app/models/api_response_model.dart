class ApiResponseModel {
  final List<String>? messages;
  final dynamic data;
  final Map<String, dynamic>? errors;

  ApiResponseModel({
    this.messages,
    this.data,
    this.errors,
  });

  factory ApiResponseModel.fromJson(Map<String, dynamic> json) {
    return ApiResponseModel(
      messages: (json['messages'] as List?)?.map((e) => e.toString()).toList(),
      data: json['data'],
      errors: json['errors'] as Map<String, dynamic>?,
    );
  }
}
