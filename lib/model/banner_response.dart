class BannerResponse {
  BannerResponse({
      this.success, 
      this.message, 
      this.data,});

  BannerResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(BannerData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  List<BannerData>? data;
BannerResponse copyWith({  bool? success,
  String? message,
  List<BannerData>? data,
}) => BannerResponse(  success: success ?? this.success,
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

class BannerData {
  BannerData({
      this.id, 
      this.imageUrl, 
      this.isActive, 
      this.sortOrder, 
      this.createdAt,});

  BannerData.fromJson(dynamic json) {
    id = json['id'];
    imageUrl = json['image_url'];
    isActive = json['is_active'];
    sortOrder = json['sort_order'];
    createdAt = json['created_at'];
  }
  String? id;
  String? imageUrl;
  bool? isActive;
  num? sortOrder;
  String? createdAt;
BannerData copyWith({  String? id,
  String? imageUrl,
  bool? isActive,
  num? sortOrder,
  String? createdAt,
}) => BannerData(  id: id ?? this.id,
  imageUrl: imageUrl ?? this.imageUrl,
  isActive: isActive ?? this.isActive,
  sortOrder: sortOrder ?? this.sortOrder,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['image_url'] = imageUrl;
    map['is_active'] = isActive;
    map['sort_order'] = sortOrder;
    map['created_at'] = createdAt;
    return map;
  }

}