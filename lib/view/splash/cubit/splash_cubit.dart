import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/header_image_response.dart';
import 'package:thredo/utils/header_images_store.dart';
import 'package:thredo/view/splash/cubit/splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitialState());

  Future<void> getImageList() async {
    final requestParams = {
      "count" : 10
    };
    try {
      final result = await DioHelper.postData(
        url: ApiConfig.imageListEP,
        data: requestParams,
        isHeader: false,
      );
      if (result.statusCode == 200) {
        final response = HeaderImageResponse.fromJson(result.data);
        final urls = response.data ?? [];
        HeaderImagesStore.setUrls(urls);
        emit(SplashImageLoadedState(imageUrls: urls));
      } else {
        emit(SplashImageErrorState());
      }
    } catch (_) {
      // Silently ignore — screens fall back to local assets.
      emit(SplashImageErrorState());
    }
  }
}
