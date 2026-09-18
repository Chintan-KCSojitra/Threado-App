class CategoryListResponse {
  CategoryListResponse({
      this.success, 
      this.message, 
      this.data, 
      this.pagination,});

  CategoryListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CategoryData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  bool? success;
  String? message;
  List<CategoryData>? data;
  Pagination? pagination;
CategoryListResponse copyWith({  bool? success,
  String? message,
  List<CategoryData>? data,
  Pagination? pagination,
}) => CategoryListResponse(  success: success ?? this.success,
  message: message ?? this.message,
  data: data ?? this.data,
  pagination: pagination ?? this.pagination,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['success'] = success;
    map['message'] = message;
    if (data != null) {
      map['data'] = data?.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      map['pagination'] = pagination?.toJson();
    }
    return map;
  }

}

class Pagination {
  Pagination({
      this.page, 
      this.perPage, 
      this.total, 
      this.totalPages, 
      this.hasNext, 
      this.hasPrev,});

  Pagination.fromJson(dynamic json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    hasNext = json['has_next'];
    hasPrev = json['has_prev'];
  }
  num? page;
  num? perPage;
  num? total;
  num? totalPages;
  bool? hasNext;
  bool? hasPrev;
Pagination copyWith({  num? page,
  num? perPage,
  num? total,
  num? totalPages,
  bool? hasNext,
  bool? hasPrev,
}) => Pagination(  page: page ?? this.page,
  perPage: perPage ?? this.perPage,
  total: total ?? this.total,
  totalPages: totalPages ?? this.totalPages,
  hasNext: hasNext ?? this.hasNext,
  hasPrev: hasPrev ?? this.hasPrev,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['page'] = page;
    map['per_page'] = perPage;
    map['total'] = total;
    map['total_pages'] = totalPages;
    map['has_next'] = hasNext;
    map['has_prev'] = hasPrev;
    return map;
  }

}

class CategoryData {
  CategoryData({
      this.id, 
      this.name, 
      this.description, 
      this.imageUrl, 
      this.isActive, 
      this.createdAt,});

  CategoryData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    imageUrl = json['image_url'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
  }
  String? id;
  String? name;
  String? description;
  String? imageUrl;
  bool? isActive;
  String? createdAt;
CategoryData copyWith({  String? id,
  String? name,
  String? description,
  String? imageUrl,
  bool? isActive,
  String? createdAt,
}) => CategoryData(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  imageUrl: imageUrl ?? this.imageUrl,
  isActive: isActive ?? this.isActive,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['image_url'] = imageUrl;
    map['is_active'] = isActive;
    map['created_at'] = createdAt;
    return map;
  }

}