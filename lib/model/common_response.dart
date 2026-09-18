import 'dart:convert';
CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));
String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());
class CommonResponse {
  CommonResponse({
      this.success, 
      this.message, 
      this.data,});

  CommonResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'];
  }
  bool? success;
  String? message;
  String? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    map['data'] = data;
    return map;
  }

}