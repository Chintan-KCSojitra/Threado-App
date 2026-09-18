import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/company_list_response.dart';
import 'package:thredo/model/product_list_response.dart' hide Colors;
import 'package:thredo/utils/helper.dart';
import 'package:thredo/view/productDetail/cubit/product_detail_state.dart';

class ProductDetailCubit extends Cubit<ProductDetailState> {
  ProductDetailCubit(ProductListData product)
    : super(ProductDetailStateData(product: product)) {
    _initialize(product);
  }

  ProductDetailStateData get dataState => state as ProductDetailStateData;

  void _initialize(ProductListData product) {
    emit(dataState.copyWith(mediaList: _buildMediaList(product)));
  }

  List<ProductMediaItem> _buildMediaList(ProductListData product) {
    final items = <ProductMediaItem>[];
    for (final media in product.media ?? <Media>[]) {
      final url = (media.url ?? '').trim();
      if (url.isEmpty) continue;
      items.add(
        ProductMediaItem(
          url: url,
          type: _isVideoMedia(media)
              ? ProductMediaType.video
              : ProductMediaType.image,
        ),
      );
    }
    return items;
  }

  bool _isVideoMedia(Media media) {
    final mediaType = (media.mediaType ?? '').toLowerCase();
    final url = (media.url ?? '').toLowerCase();
    return mediaType.contains('video') ||
        url.endsWith('.mp4') ||
        url.endsWith('.mov') ||
        url.endsWith('.webm') ||
        url.endsWith('.m3u8');
  }

  void onPageChanged(int index) {
    emit(
      dataState.copyWith(
        currentPage: index,
        currentIndex: index,
        videoHasError: false,
        videoLoading: false,
      ),
    );
  }

  void setVideoLoading(bool value) {
    emit(dataState.copyWith(videoLoading: value));
  }

  void setVideoError(bool value) {
    emit(dataState.copyWith(videoHasError: value));
  }

  Future<void> addToWishlistApi(String productId) async {
    final requestParam = {'product_id': productId};
    final response = await DioHelper.postData(
      url: ApiConfig.addToWishListEP,
      data: requestParam,
      isHeader: true,
    );
    if (response.statusCode == 200 || response.statusCode == 201) {
      return;
    }
    final message = response.data is Map<String, dynamic>
        ? (response.data['message']?.toString() ?? 'Unable to update wishlist')
        : 'Unable to update wishlist';
    throw Exception(message);
  }

  Future<void> onWishlistTap() async {
    if (dataState.isWishlistLoading) return;

    final previous = dataState.isLiked;
    emit(dataState.copyWith(isLiked: !previous, isWishlistLoading: true));

    try {
      final productId = dataState.product.id;
      if (productId == null || productId.trim().isEmpty) {
        throw Exception('Invalid product id');
      }
      await addToWishlistApi(productId);
    } catch (error) {
      emit(dataState.copyWith(isLiked: previous));
      showMessage(message: getErrorMessage(error) ?? error.toString());
    } finally {
      emit(dataState.copyWith(isWishlistLoading: false));
    }
  }

  Future<void> screenCaptureEvent(String productId) async {
    final requestParam = {
      'event_type': 'product_screen_shot',
      'product_id': productId,
      'platform': Platform.isIOS ? 'ios' : 'android',
    };
    try {
      await DioHelper.postData(
        url: ApiConfig.logEventEP,
        data: requestParam,
        isHeader: true,
      );
    } catch (_) {
      // Ignore analytics errors
    }
  }

  Future<void> logProductEvent(String eventType, String productId) async {
    final requestParam = {
      'event_type': eventType,
      'product_id': productId,
      'platform': Platform.isIOS ? 'ios' : 'android',
    };
    try {
      await DioHelper.postData(
        url: ApiConfig.logEventEP,
        data: requestParam,
        isHeader: true,
      );
    } catch (_) {
      // Ignore analytics errors
    }
  }

  Future<void> whatsappClickEvent(String productId) async {
    await logProductEvent('whatsapp_button_click', productId);
  }

  Future<CompanyListData?> fetchCompanyDetails() async {
    final companyId = dataState.product.companyId;
    if (companyId == null || companyId.trim().isEmpty) {
      showMessage(message: 'Company ID is not available');
      return null;
    }

    emit(dataState.copyWith(isCompanyLoading: true));
    try {
      final result = await DioHelper.getData(
        url: '${ApiConfig.companyDetailEP}/$companyId',
        isHeader: true,
        enableCache: false,
        forceRefresh: true,
      );

      if (result.statusCode == 200) {
        return CompanyListData.fromJson(result.data['data']);
      } else {
        throw Exception('Failed to fetch company details');
      }
    } catch (e) {
      showMessage(message: getErrorMessage(e) ?? 'Failed to fetch company details');
      return null;
    } finally {
      emit(dataState.copyWith(isCompanyLoading: false));
    }
  }
}
