import 'package:thredo/model/product_list_response.dart' hide Colors;

enum ProductMediaType { image, video }

class ProductMediaItem {
  final String url;
  final ProductMediaType type;

  const ProductMediaItem({required this.url, required this.type});
}

abstract class ProductDetailState {
  const ProductDetailState();
}

class ProductDetailStateData extends ProductDetailState {
  final ProductListData product;
  final List<ProductMediaItem> mediaList;
  final int currentPage;
  final int currentIndex;
  final bool videoLoading;
  final bool videoHasError;
  final bool isLiked;
  final bool isWishlistLoading;
  final bool isCompanyLoading;

  const ProductDetailStateData({
    required this.product,
    this.mediaList = const [],
    this.currentPage = 0,
    this.currentIndex = 0,
    this.videoLoading = false,
    this.videoHasError = false,
    this.isLiked = false,
    this.isWishlistLoading = false,
    this.isCompanyLoading = false,
  }) : super();

  String get productName {
    final name = (product.name ?? '').trim();
    return name.isEmpty ? 'Product' : name;
  }

  String get productDescription {
    final description = (product.description ?? '').trim();
    return description.isEmpty
        ? 'Details are not available for this product.'
        : description;
  }

  List<String> get infoChips => <String>[
    'MOQ: ${product.minQuantity ?? '-'}',
    'Stock: ${product.stock ?? '-'}',
    'Lead Time: ${product.manufacturingTime ?? '-'}',
  ];

  String get materialAndFinish {
    final materials = (product.materials ?? [])
        .map((item) => item.name)
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .join(', ');
    return 'Materials: ${materials.isEmpty ? '-' : materials}\nDenier: ${product.denier ?? '-'}';
  }

  String get recommendedUsage {
    final colors = (product.colors ?? [])
        .map((item) => item.name)
        .whereType<String>()
        .where((name) => name.trim().isNotEmpty)
        .join(', ');
    return 'Available Colors: ${colors.isEmpty ? '-' : colors}\nPacking: ${product.packing ?? '-'}';
  }

  String get firstImageUrl {
    final images = mediaList
        .where((item) => item.type == ProductMediaType.image)
        .map((item) => item.url);
    return images.isEmpty ? '' : images.first;
  }

  ProductDetailStateData copyWith({
    ProductListData? product,
    List<ProductMediaItem>? mediaList,
    int? currentPage,
    int? currentIndex,
    bool? videoLoading,
    bool? videoHasError,
    bool? isLiked,
    bool? isWishlistLoading,
    bool? isCompanyLoading,
  }) {
    return ProductDetailStateData(
      product: product ?? this.product,
      mediaList: mediaList ?? this.mediaList,
      currentPage: currentPage ?? this.currentPage,
      currentIndex: currentIndex ?? this.currentIndex,
      videoLoading: videoLoading ?? this.videoLoading,
      videoHasError: videoHasError ?? this.videoHasError,
      isLiked: isLiked ?? this.isLiked,
      isWishlistLoading: isWishlistLoading ?? this.isWishlistLoading,
      isCompanyLoading: isCompanyLoading ?? this.isCompanyLoading,
    );
  }
}
