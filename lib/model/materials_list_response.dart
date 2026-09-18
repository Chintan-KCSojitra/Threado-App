class MaterialsListResponse {
  MaterialsListResponse({
      this.success, 
      this.message, 
      this.data,});

  MaterialsListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(MaterialsData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  List<MaterialsData>? data;
MaterialsListResponse copyWith({  bool? success,
  String? message,
  List<MaterialsData>? data,
}) => MaterialsListResponse(  success: success ?? this.success,
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

class MaterialsData {
  MaterialsData({
      this.id, 
      this.name, 
      this.description, 
      this.isActive,});

  MaterialsData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
  }
  String? id;
  String? name;
  String? description;
  bool? isActive;
MaterialsData copyWith({  String? id,
  String? name,
  String? description,
  bool? isActive,
}) => MaterialsData(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  isActive: isActive ?? this.isActive,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['is_active'] = isActive;
    return map;
  }

}