
class HomeData {
  String productImage;
  String productVideo;

  HomeData({required this.productImage, required this.productVideo});
}

enum MediaType { image, video }

class MediaItem {
  final String asset;
  final MediaType type;

  MediaItem({required this.asset, required this.type});
}


