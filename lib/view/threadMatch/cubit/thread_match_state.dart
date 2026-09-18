import 'package:thredo/model/product_list_response.dart';

abstract class ThreadMatchState {}

class ThreadMatchStateData extends ThreadMatchState {
  ThreadMatchStateData({
    this.pickedImagePath,
    this.products = const [],
    this.isScanning = false,
    this.hasResult = false,
    this.errorMessage,
  });

  final String? pickedImagePath;
  final List<ProductListData> products;
  final bool isScanning;
  final bool hasResult;
  final String? errorMessage;

  ThreadMatchStateData copyWith({
    String? pickedImagePath,
    List<ProductListData>? products,
    bool? isScanning,
    bool? hasResult,
    String? errorMessage,
    bool clearErrorMessage = false,
    bool clearImage = false,
  }) {
    return ThreadMatchStateData(
      pickedImagePath:
          clearImage ? null : (pickedImagePath ?? this.pickedImagePath),
      products: products ?? this.products,
      isScanning: isScanning ?? this.isScanning,
      hasResult: hasResult ?? this.hasResult,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class ThreadMatchInitialState extends ThreadMatchStateData {}
