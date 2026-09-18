class HeaderImageResponse {
  HeaderImageResponse({
      this.success, 
      this.message, 
      this.data,});

  HeaderImageResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? json['data'].cast<String>() : [];
  }
  bool? success;
  String? message;
  List<String>? data;
HeaderImageResponse copyWith({  bool? success,
  String? message,
  List<String>? data,
}) => HeaderImageResponse(  success: success ?? this.success,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}