class WishListResponse {
  WishListResponse({
      this.success, 
      this.message, 
      this.data,});

  WishListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(WishListData.fromJson(v));
      });
    }
  }
  bool? success;
  String? message;
  List<WishListData>? data;
WishListResponse copyWith({  bool? success,
  String? message,
  List<WishListData>? data,
}) => WishListResponse(  success: success ?? this.success,
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

class WishListData {
  WishListData({
      this.id, 
      this.userId, 
      this.productId, 
      this.createdAt, 
      this.product,});

  WishListData.fromJson(dynamic json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    createdAt = json['created_at'];
    product = json['product'] != null ? Product.fromJson(json['product']) : null;
  }
  String? id;
  String? userId;
  String? productId;
  String? createdAt;
  Product? product;
WishListData copyWith({  String? id,
  String? userId,
  String? productId,
  String? createdAt,
  Product? product,
}) => WishListData(  id: id ?? this.id,
  userId: userId ?? this.userId,
  productId: productId ?? this.productId,
  createdAt: createdAt ?? this.createdAt,
  product: product ?? this.product,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['user_id'] = userId;
    map['product_id'] = productId;
    map['created_at'] = createdAt;
    if (product != null) {
      map['product'] = product?.toJson();
    }
    return map;
  }

}

class Product {
  Product({
      this.id, 
      this.name, 
      this.description, 
      this.price, 
      this.stock, 
      this.isActive, 
      this.companyId, 
      this.createdAt, 
      this.media, 
      this.colors, 
      this.materials, 
      this.denier, 
      this.meter, 
      this.packing, 
      this.pis, 
      this.grossWeight, 
      this.netWeight, 
      this.tubeSize, 
      this.minQuantity, 
      this.stockDetails, 
      this.manufacturingTime,});

  Product.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    isActive = json['is_active'];
    companyId = json['company_id'];
    createdAt = json['created_at'];
    if (json['media'] != null) {
      media = [];
      json['media'].forEach((v) {
        media?.add(Media.fromJson(v));
      });
    }
    if (json['colors'] != null) {
      colors = [];
      json['colors'].forEach((v) {
        colors?.add(Colors.fromJson(v));
      });
    }
    if (json['materials'] != null) {
      materials = [];
      json['materials'].forEach((v) {
        materials?.add(Materials.fromJson(v));
      });
    }
    denier = json['denier'];
    meter = json['meter'];
    packing = json['packing'];
    pis = json['pis'];
    grossWeight = json['gross_weight'];
    netWeight = json['net_weight'];
    tubeSize = json['tube_size'];
    minQuantity = json['min_quantity'];
    stockDetails = json['stock_details'];
    manufacturingTime = json['manufacturing_time'];
  }
  String? id;
  String? name;
  String? description;
  num? price;
  num? stock;
  bool? isActive;
  String? companyId;
  String? createdAt;
  List<Media>? media;
  List<Colors>? colors;
  List<Materials>? materials;
  String? denier;
  num? meter;
  String? packing;
  String? pis;
  num? grossWeight;
  num? netWeight;
  String? tubeSize;
  num? minQuantity;
  String? stockDetails;
  String? manufacturingTime;
Product copyWith({  String? id,
  String? name,
  String? description,
  num? price,
  num? stock,
  bool? isActive,
  String? companyId,
  String? createdAt,
  List<Media>? media,
  List<Colors>? colors,
  List<Materials>? materials,
  String? denier,
  num? meter,
  String? packing,
  String? pis,
  num? grossWeight,
  num? netWeight,
  String? tubeSize,
  num? minQuantity,
  String? stockDetails,
  String? manufacturingTime,
}) => Product(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  price: price ?? this.price,
  stock: stock ?? this.stock,
  isActive: isActive ?? this.isActive,
  companyId: companyId ?? this.companyId,
  createdAt: createdAt ?? this.createdAt,
  media: media ?? this.media,
  colors: colors ?? this.colors,
  materials: materials ?? this.materials,
  denier: denier ?? this.denier,
  meter: meter ?? this.meter,
  packing: packing ?? this.packing,
  pis: pis ?? this.pis,
  grossWeight: grossWeight ?? this.grossWeight,
  netWeight: netWeight ?? this.netWeight,
  tubeSize: tubeSize ?? this.tubeSize,
  minQuantity: minQuantity ?? this.minQuantity,
  stockDetails: stockDetails ?? this.stockDetails,
  manufacturingTime: manufacturingTime ?? this.manufacturingTime,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['price'] = price;
    map['stock'] = stock;
    map['is_active'] = isActive;
    map['company_id'] = companyId;
    map['created_at'] = createdAt;
    if (media != null) {
      map['media'] = media?.map((v) => v.toJson()).toList();
    }
    if (colors != null) {
      map['colors'] = colors?.map((v) => v.toJson()).toList();
    }
    if (materials != null) {
      map['materials'] = materials?.map((v) => v.toJson()).toList();
    }
    map['denier'] = denier;
    map['meter'] = meter;
    map['packing'] = packing;
    map['pis'] = pis;
    map['gross_weight'] = grossWeight;
    map['net_weight'] = netWeight;
    map['tube_size'] = tubeSize;
    map['min_quantity'] = minQuantity;
    map['stock_details'] = stockDetails;
    map['manufacturing_time'] = manufacturingTime;
    return map;
  }

}

class Materials {
  Materials({
      this.id, 
      this.name, 
      this.description, 
      this.isActive,});

  Materials.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    isActive = json['is_active'];
  }
  String? id;
  String? name;
  String? description;
  bool? isActive;
Materials copyWith({  String? id,
  String? name,
  String? description,
  bool? isActive,
}) => Materials(  id: id ?? this.id,
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

class Colors {
  Colors({
      this.id, 
      this.name, 
      this.hexCode, 
      this.isActive,});

  Colors.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    hexCode = json['hex_code'];
    isActive = json['is_active'];
  }
  String? id;
  String? name;
  String? hexCode;
  bool? isActive;
Colors copyWith({  String? id,
  String? name,
  String? hexCode,
  bool? isActive,
}) => Colors(  id: id ?? this.id,
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

class Media {
  Media({
      this.id, 
      this.mediaType, 
      this.url, 
      this.thumbnailUrl, 
      this.title, 
      this.isPrimary, 
      this.sortOrder,});

  Media.fromJson(dynamic json) {
    id = json['id'];
    mediaType = json['media_type'];
    url = json['url'];
    thumbnailUrl = json['thumbnail_url'];
    title = json['title'];
    isPrimary = json['is_primary'];
    sortOrder = json['sort_order'];
  }
  String? id;
  String? mediaType;
  String? url;
  dynamic thumbnailUrl;
  dynamic title;
  bool? isPrimary;
  num? sortOrder;
Media copyWith({  String? id,
  String? mediaType,
  String? url,
  dynamic thumbnailUrl,
  dynamic title,
  bool? isPrimary,
  num? sortOrder,
}) => Media(  id: id ?? this.id,
  mediaType: mediaType ?? this.mediaType,
  url: url ?? this.url,
  thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
  title: title ?? this.title,
  isPrimary: isPrimary ?? this.isPrimary,
  sortOrder: sortOrder ?? this.sortOrder,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['media_type'] = mediaType;
    map['url'] = url;
    map['thumbnail_url'] = thumbnailUrl;
    map['title'] = title;
    map['is_primary'] = isPrimary;
    map['sort_order'] = sortOrder;
    return map;
  }

}