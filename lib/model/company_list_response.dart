class CompanyListResponse {
  CompanyListResponse({
      this.success, 
      this.message, 
      this.data, 
      this.pagination,});

  CompanyListResponse.fromJson(dynamic json) {
    success = json['success'];
    message = json['message'];
    if (json['data'] != null) {
      data = [];
      json['data'].forEach((v) {
        data?.add(CompanyListData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null ? Pagination.fromJson(json['pagination']) : null;
  }
  bool? success;
  String? message;
  List<CompanyListData>? data;
  Pagination? pagination;
CompanyListResponse copyWith({  bool? success,
  String? message,
  List<CompanyListData>? data,
  Pagination? pagination,
}) => CompanyListResponse(  success: success ?? this.success,
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

class CompanyListData {
  CompanyListData({
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
      this.shadeCardEnabled, 
      this.shadeCards, 
      this.averageRating, 
      this.reviewCount,
      this.userReview,
      this.reviews,
      this.createdAt,});

  CompanyListData.fromJson(dynamic json) {
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
    shadeCardEnabled = json['shade_card_enabled'];
    if (json['shade_cards'] != null) {
      shadeCards = [];
      json['shade_cards'].forEach((v) {
        shadeCards?.add(ShadeCards.fromJson(v));
      });
    }
    averageRating = json['average_rating'];
    reviewCount = json['review_count'];
    userReview = json['user_review'] != null
        ? CompanyReview.fromJson(json['user_review'])
        : null;
    if (json['reviews'] != null) {
      reviews = [];
      json['reviews'].forEach((v) {
        reviews?.add(CompanyReview.fromJson(v));
      });
    }
    createdAt = json['created_at'];
  }
  String? id;
  String? name;
  String? description;
  String? logoUrl;
  dynamic bannerUrl;
  String? address;
  String? city;
  String? state;
  String? country;
  String? pincode;
  String? email;
  String? phone;
  dynamic website;
  bool? isActive;
  String? instagramUrl;
  String? facebookUrl;
  dynamic twitterUrl;
  String? youtubeUrl;
  dynamic linkedinUrl;
  String? whatsappNumber;
  bool? shadeCardEnabled;
  List<ShadeCards>? shadeCards;
  num? averageRating;
  num? reviewCount;
  CompanyReview? userReview;
  List<CompanyReview>? reviews;
  String? createdAt;

  bool get hasUserReviewed => userReview != null;

  List<CompanyReview> get sortedReviews {
    final list = List<CompanyReview>.from(reviews ?? const []);
    list.sort((a, b) {
      final aDate = DateTime.tryParse(a.createdAt ?? '') ?? DateTime(1970);
      final bDate = DateTime.tryParse(b.createdAt ?? '') ?? DateTime(1970);
      return bDate.compareTo(aDate);
    });
    return list;
  }

  CompanyListData withSubmittedReview({
    required int rating,
    required String reviewText,
  }) {
    final newReview = CompanyReview(
      companyId: id,
      rating: rating,
      reviewText: reviewText,
      createdAt: DateTime.now().toUtc().toIso8601String(),
      isApproved: true,
    );
    final existing = reviews ?? [];
    final previousCount = reviewCount ?? existing.length;
    final newCount = previousCount + 1;
    final previousTotal = (averageRating ?? 0) * previousCount;
    final newAverage = newCount > 0
        ? (previousTotal + rating) / newCount
        : rating.toDouble();

    return copyWith(
      userReview: newReview,
      reviews: [newReview, ...existing],
      reviewCount: newCount,
      averageRating: newAverage,
    );
  }

CompanyListData copyWith({  String? id,
  String? name,
  String? description,
  String? logoUrl,
  dynamic bannerUrl,
  String? address,
  String? city,
  String? state,
  String? country,
  String? pincode,
  String? email,
  String? phone,
  dynamic website,
  bool? isActive,
  String? instagramUrl,
  String? facebookUrl,
  dynamic twitterUrl,
  String? youtubeUrl,
  dynamic linkedinUrl,
  String? whatsappNumber,
  bool? shadeCardEnabled,
  List<ShadeCards>? shadeCards,
  num? averageRating,
  num? reviewCount,
  CompanyReview? userReview,
  List<CompanyReview>? reviews,
  String? createdAt,
}) => CompanyListData(  id: id ?? this.id,
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
  shadeCardEnabled: shadeCardEnabled ?? this.shadeCardEnabled,
  shadeCards: shadeCards ?? this.shadeCards,
  averageRating: averageRating ?? this.averageRating,
  reviewCount: reviewCount ?? this.reviewCount,
  userReview: userReview ?? this.userReview,
  reviews: reviews ?? this.reviews,
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
    map['shade_card_enabled'] = shadeCardEnabled;
    if (shadeCards != null) {
      map['shade_cards'] = shadeCards?.map((v) => v.toJson()).toList();
    }
    map['average_rating'] = averageRating;
    map['review_count'] = reviewCount;
    if (userReview != null) {
      map['user_review'] = userReview!.toJson();
    }
    if (reviews != null) {
      map['reviews'] = reviews?.map((v) => v.toJson()).toList();
    }
    map['created_at'] = createdAt;
    return map;
  }

}

class CompanyReview {
  CompanyReview({
    this.id,
    this.companyId,
    this.userId,
    this.rating,
    this.reviewText,
    this.isApproved,
    this.helpfulCount,
    this.createdAt,
    this.updatedAt,
    this.user,
  });

  CompanyReview.fromJson(dynamic json) {
    id = json['id'];
    companyId = json['company_id'];
    userId = json['user_id'];
    rating = json['rating'];
    reviewText = json['review_text'];
    isApproved = json['is_approved'];
    helpfulCount = json['helpful_count'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    user = json['user'] != null ? ReviewUser.fromJson(json['user']) : null;
  }

  String? id;
  String? companyId;
  String? userId;
  num? rating;
  String? reviewText;
  bool? isApproved;
  num? helpfulCount;
  String? createdAt;
  String? updatedAt;
  ReviewUser? user;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['company_id'] = companyId;
    map['user_id'] = userId;
    map['rating'] = rating;
    map['review_text'] = reviewText;
    map['is_approved'] = isApproved;
    map['helpful_count'] = helpfulCount;
    map['created_at'] = createdAt;
    map['updated_at'] = updatedAt;
    if (user != null) {
      map['user'] = user!.toJson();
    }
    return map;
  }
}

class ReviewUser {
  ReviewUser({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.role,
    this.isActive,
    this.avatarUrl,
    this.createdAt,
  });

  ReviewUser.fromJson(dynamic json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    isActive = json['is_active'];
    avatarUrl = json['avatar_url'];
    createdAt = json['created_at'];
  }

  String? id;
  String? name;
  String? email;
  String? phone;
  String? role;
  bool? isActive;
  String? avatarUrl;
  String? createdAt;

  String get displayName {
    final trimmedName = (name ?? '').trim();
    if (trimmedName.isNotEmpty) return trimmedName;
    final trimmedPhone = (phone ?? '').trim();
    if (trimmedPhone.isNotEmpty) return trimmedPhone;
    return 'User';
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['name'] = name;
    map['email'] = email;
    map['phone'] = phone;
    map['role'] = role;
    map['is_active'] = isActive;
    map['avatar_url'] = avatarUrl;
    map['created_at'] = createdAt;
    return map;
  }
}

class ShadeCards {
  ShadeCards({
      this.id, 
      this.companyId, 
      this.imageUrl, 
      this.name, 
      this.createdAt,});

  ShadeCards.fromJson(dynamic json) {
    id = json['id'];
    companyId = json['company_id'];
    imageUrl = json['image_url'];
    name = json['name'];
    createdAt = json['created_at'];
  }
  String? id;
  String? companyId;
  String? imageUrl;
  dynamic name;
  String? createdAt;
ShadeCards copyWith({  String? id,
  String? companyId,
  String? imageUrl,
  dynamic name,
  String? createdAt,
}) => ShadeCards(  id: id ?? this.id,
  companyId: companyId ?? this.companyId,
  imageUrl: imageUrl ?? this.imageUrl,
  name: name ?? this.name,
  createdAt: createdAt ?? this.createdAt,
);
  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['company_id'] = companyId;
    map['image_url'] = imageUrl;
    map['name'] = name;
    map['created_at'] = createdAt;
    return map;
  }

}