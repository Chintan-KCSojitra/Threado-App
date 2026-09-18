import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/product_list_response.dart';
import 'package:thredo/view/threadMatch/cubit/thread_match_state.dart';

class ThreadMatchCubit extends Cubit<ThreadMatchState> {
  ThreadMatchCubit() : super(ThreadMatchInitialState());

  final ImagePicker _picker = ImagePicker();

  ThreadMatchStateData get _dataState => state as ThreadMatchStateData;

  // ── Pick from gallery ────────────────────────────────────────────────────

  Future<void> pickFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (file == null) return;
    emit(_dataState.copyWith(
      pickedImagePath: file.path,
      products: [],
      hasResult: false,
      clearErrorMessage: true,
    ));
    await _scanImage(file.path);
  }

  // ── Pick from camera ─────────────────────────────────────────────────────

  Future<void> pickFromCamera() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1920,
      maxHeight: 1920,
      imageQuality: 85,
    );
    if (file == null) return;
    emit(_dataState.copyWith(
      pickedImagePath: file.path,
      products: [],
      hasResult: false,
      clearErrorMessage: true,
    ));
    await _scanImage(file.path);
  }

  // ── Reset ────────────────────────────────────────────────────────────────

  void reset() {
    emit(ThreadMatchInitialState());
  }

  // ── Scan image ───────────────────────────────────────────────────────────

  Future<void> _scanImage(String imagePath) async {
    emit(_dataState.copyWith(isScanning: true, clearErrorMessage: true));
    try {
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          imagePath,
          filename: imagePath.split('/').last,
        ),
      });


      final result = await DioHelper.postData(
        url: ApiConfig.matchThreadEP,
        formData: formData,
        isHeader: true,
      );

      if (result.statusCode == 200) {
        final response = ProductListResponse.fromJson(result.data);
        final products = response.data ?? [];
        emit(_dataState.copyWith(
          products: products,
          isScanning: false,
          hasResult: true,
          clearErrorMessage: true,
        ));
      } else {
        final rawData = result.data;
        String message = 'Scan failed';
        if (rawData is Map<String, dynamic>) {
          message = rawData['detail']?.toString() ??
              rawData['message']?.toString() ??
              'Scan failed';
        }
        emit(_dataState.copyWith(
          isScanning: false,
          hasResult: true,
          errorMessage: message,
        ));
      }
    } on DioException catch (e) {
      String msg = 'Something went wrong. Please try again.';
      if (e.response?.data is Map<String, dynamic>) {
        final data = e.response!.data as Map<String, dynamic>;
        msg = data['detail']?.toString() ?? data['message']?.toString() ?? msg;
      }
      emit(_dataState.copyWith(
        isScanning: false,
        hasResult: true,
        errorMessage: msg,
      ));
    } catch (e) {
      emit(_dataState.copyWith(
        isScanning: false,
        hasResult: true,
        errorMessage: 'Something went wrong. Please try again.',
      ));
    }
  }
}
