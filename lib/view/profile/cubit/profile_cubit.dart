import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/utils/helper.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/profile/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit() : super(ProfileInitialState());

  Future<void> logout() async {
    emit(LoadingState());

    try {
      final response = await DioHelper.postData(
        url: ApiConfig.logoutEP,
        isHeader: true,
      );
      if (response.statusCode == 200) {
        await SharedPreferenceUtil.clearData();
        await SharedPreferenceUtil.putValue(kPrefIsLogin, false);
        await SharedPreferenceUtil.putValue(kPrefDeviceToken, '');
        emit(LoadedState());
      } else {
        showMessage(message: response.statusMessage.toString());
        emit(ErrorState());
      }
    } catch (e) {
      showMessage(message: e.toString());
      emit(ErrorState());
    }
  }

  Future<void> deleteAccount() async {
    emit(LoadingState());

    try {
      final response = await DioHelper.deleteData(
        url: ApiConfig.logoutEP,
        isHeader: true,
      );
      if (response.statusCode == 200) {
        await SharedPreferenceUtil.clearData();
        await SharedPreferenceUtil.putValue(kPrefIsLogin, false);
        await SharedPreferenceUtil.putValue(kPrefDeviceToken, '');
        emit(LoadedState());
      } else {
        showMessage(message: response.statusMessage.toString());
        emit(ErrorState());
      }
    } catch (e) {
      showMessage(message: e.toString());
      emit(ErrorState());
    }
  }
}
