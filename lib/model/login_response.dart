import 'dart:convert';
LoginResponse loginResponseFromJson(String str) => LoginResponse.fromJson(json.decode(str));
String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());
class LoginResponse {
  LoginResponse({
      this.success, 
      this.message, 
      this.data,});

  LoginResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    data = json['data'] != null ? LoginData.fromJson(json['data']) : null;
  }
  bool? success;
  String? message;
  LoginData? data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.toJson();
    }
    return map;
  }

}

LoginData dataFromJson(String str) => LoginData.fromJson(json.decode(str));
String dataToJson(LoginData data) => json.encode(data.toJson());
class LoginData {
  LoginData({
      this.accessToken, 
      this.tokenType, 
      this.userId, 
      this.role,
      this.phone,
  });

  LoginData.fromJson(dynamic json) {
    accessToken = json['access_token'];
    tokenType = json['token_type'];
    userId = json['user_id'];
    role = json['role'];
    phone = json['phone'];
  }
  String? accessToken;
  String? tokenType;
  String? userId;
  String? role;
  String? phone;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['access_token'] = accessToken;
    map['token_type'] = tokenType;
    map['user_id'] = userId;
    map['role'] = role;
    map['phone'] = phone;
    return map;
  }

}