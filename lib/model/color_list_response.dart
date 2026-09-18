class ColorListResponse {
  ColorListResponse({
      this.success, 
      this.message, 
      this.data,});

  ColorListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ColorListData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  List<ColorListData>? data;
ColorListResponse copyWith({  bool? success,
  String? message,
  List<ColorListData>? data,
}) => ColorListResponse(  success: success ?? this.success,
  message: message ?? this.message,
  data: data ?? this.data,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

class ColorListData {
  ColorListData({
      this.id, 
      this.name, 
      this.hexCode, 
      this.isActive,});

  ColorListData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    hexCode = json['hex_code'];
    isActive = json['is_active'];
  }
  String? id;
  String? name;
  String? hexCode;
  bool? isActive;
ColorListData copyWith({  String? id,
  String? name,
  String? hexCode,
  bool? isActive,
}) => ColorListData(  id: id ?? this.id,
  name: name ?? this.name,
  hexCode: hexCode ?? this.hexCode,
  isActive: isActive ?? this.isActive,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['hex_code'] = hexCode;
    map['is_active'] = isActive;
    return map;
  }

}