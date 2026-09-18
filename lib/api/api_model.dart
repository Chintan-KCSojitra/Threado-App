class ApiResponse<T> {
  const ApiResponse({required this.status, required this.message, this.data});

  factory ApiResponse.fromJson(final Map<String, dynamic> json, final T Function(Map<String, dynamic>) fromJsonT) => ApiResponse(
        status: json['status'] as int? ?? 0,
        message: json['message'] as String? ?? '',
        data: json['data'] != null ? fromJsonT(json['data'] as Map<String, dynamic>) : null,
      );

  final int status;

  final String message;
  final T? data;

  Map<String, dynamic> toJson(final Map<String, dynamic> Function(T) toJsonT) => {
        'status': status,
        'message': message,
        'data': data != null ? toJsonT(data as T) : null,
      };
}
