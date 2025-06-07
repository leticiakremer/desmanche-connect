class ApiResponseModel<T> {
  final String? message;
  final int? statusCode;
  final T? data;

  ApiResponseModel({
    this.message,
    this.statusCode,
    this.data,
  });

  factory ApiResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponseModel<T>(
      message: json['message'] as String?,
      statusCode: json['statusCode'] as int?,
      data: json['data'] != null ? fromJsonT(json['data']) : null,
    );
  }
}
