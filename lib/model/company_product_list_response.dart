import 'package:thredo/model/product_list_response.dart';

class CompanyProductListResponse {
  CompanyProductListResponse({
      this.success, 
      this.message, 
      this.data, 
      this.pagination,});

  CompanyProductListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(ProductListData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  bool? success;
  String? message;
  List<ProductListData>? data;
  Pagination? pagination;
CompanyProductListResponse copyWith({  bool? success,
  String? message,
  List<ProductListData>? data,
  Pagination? pagination,
}) => CompanyProductListResponse(  success: success ?? this.success,
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

class CompanyProductData {
  CompanyProductData({
      this.id, 
      this.name, 
      this.description, 
      this.price, 
      this.stock, 
      this.isActive, 
      this.companyId, 
      this.categoryId, 
      this.category, 
      this.company, 
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

  CompanyProductData.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    isActive = json['is_active'];
    companyId = json['company_id'];
    categoryId = json['category_id'];
    category = json['category'] != null ? Category.fromJson(json['category']) : null;
    company = json['company'] != null ? Company.fromJson(json['company']) : null;
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
  String? categoryId;
  Category? category;
  Company? company;
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
CompanyProductData copyWith({  String? id,
  String? name,
  String? description,
  num? price,
  num? stock,
  bool? isActive,
  String? companyId,
  String? categoryId,
  Category? category,
  Company? company,
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
}) => CompanyProductData(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  price: price ?? this.price,
  stock: stock ?? this.stock,
  isActive: isActive ?? this.isActive,
  companyId: companyId ?? this.companyId,
  categoryId: categoryId ?? this.categoryId,
  category: category ?? this.category,
  company: company ?? this.company,
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
    map['category_id'] = categoryId;
    if (category != null) {
      map['category'] = category?.toJson();
    }
    if (company != null) {
      map['company'] = company?.toJson();
    }
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

class Company {
  Company({
      this.id, 
      this.name, 
      this.description, 
      this.logoUrl, 
      this.bannerUrl, 
      this.address, 
      this.city, 
      this.state, 
      this.country, 
      this.pincode, 
      this.email, 
      this.phone, 
      this.website, 
      this.isActive, 
      this.instagramUrl, 
      this.facebookUrl, 
      this.twitterUrl, 
      this.youtubeUrl, 
      this.linkedinUrl, 
      this.whatsappNumber, 
      this.createdAt,});

  Company.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    logoUrl = json['logo_url'];
    bannerUrl = json['banner_url'];
    address = json['address'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    pincode = json['pincode'];
    email = json['email'];
    phone = json['phone'];
    website = json['website'];
    isActive = json['is_active'];
    instagramUrl = json['instagram_url'];
    facebookUrl = json['facebook_url'];
    twitterUrl = json['twitter_url'];
    youtubeUrl = json['youtube_url'];
    linkedinUrl = json['linkedin_url'];
    whatsappNumber = json['whatsapp_number'];
    createdAt = json['created_at'];
  }
  String? id;
  String? name;
  String? description;
  String? logoUrl;
  String? bannerUrl;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? email;
  String? phone;
  String? website;
  bool? isActive;
  String? instagramUrl;
  String? facebookUrl;
  String? twitterUrl;
  String? youtubeUrl;
  String? linkedinUrl;
  String? whatsappNumber;
  String? createdAt;
Company copyWith({  String? id,
  String? name,
  String? description,
  String? logoUrl,
  String? bannerUrl,
  String? address,
  String? city,
  String? state,
  String? country,
  String? pincode,
  String? email,
  String? phone,
  String? website,
  bool? isActive,
  String? instagramUrl,
  String? facebookUrl,
  String? twitterUrl,
  String? youtubeUrl,
  String? linkedinUrl,
  String? whatsappNumber,
  String? createdAt,
}) => Company(  id: id ?? this.id,
  name: name ?? this.name,
  description: description ?? this.description,
  logoUrl: logoUrl ?? this.logoUrl,
  bannerUrl: bannerUrl ?? this.bannerUrl,
  address: address ?? this.address,
  city: city ?? this.city,
  state: state ?? this.state,
  country: country ?? this.country,
  pincode: pincode ?? this.pincode,
  email: email ?? this.email,
  phone: phone ?? this.phone,
  website: website ?? this.website,
  isActive: isActive ?? this.isActive,
  instagramUrl: instagramUrl ?? this.instagramUrl,
  facebookUrl: facebookUrl ?? this.facebookUrl,
  twitterUrl: twitterUrl ?? this.twitterUrl,
  youtubeUrl: youtubeUrl ?? this.youtubeUrl,
  linkedinUrl: linkedinUrl ?? this.linkedinUrl,
  whatsappNumber: whatsappNumber ?? this.whatsappNumber,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['description'] = description;
    map['logo_url'] = logoUrl;
    map['banner_url'] = bannerUrl;
    map['address'] = address;
    map['city'] = city;
    map['state'] = state;
    map['country'] = country;
    map['pincode'] = pincode;
    map['email'] = email;
    map['phone'] = phone;
    map['website'] = website;
    map['is_active'] = isActive;
    map['instagram_url'] = instagramUrl;
    map['facebook_url'] = facebookUrl;
    map['twitter_url'] = twitterUrl;
    map['youtube_url'] = youtubeUrl;
    map['linkedin_url'] = linkedinUrl;
    map['whatsapp_number'] = whatsappNumber;
    map['created_at'] = createdAt;
    return map;
  }

}

class Category {
  Category({
      this.id, 
      this.name, 
      this.description, 
      this.imageUrl, 
      this.isActive, 
      this.createdAt,});

  Category.fromJson(dynamic json) {
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
Category copyWith({  String? id,
  String? name,
  String? description,
  String? imageUrl,
  bool? isActive,
  String? createdAt,
}) => Category(  id: id ?? this.id,
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