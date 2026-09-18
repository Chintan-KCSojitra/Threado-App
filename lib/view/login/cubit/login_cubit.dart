import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/utils/helper.dart';
import 'package:thredo/view/login/cubit/login_state.dart';
import 'package:thredo/model/login_response.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/utils/shared_preference_util.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitialState());

  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future<void> login() async {
    final phoneNumber = mobileNumberController.text.trim();
    final password = passwordController.text.trim();
    
    if (phoneNumber.isEmpty) {
      const errorMessage = 'Please enter mobile number';
      showMessage(message: errorMessage);
      emit(ErrorState(message: errorMessage));
      return;
    }
    if (password.isEmpty) {
      const errorMessage = 'Please enter password';
      showMessage(message: errorMessage);
      emit(ErrorState(message: errorMessage));
      return;
    }

    emit(LoadingState());
    
    // Add country code +91 if needed, assuming backend requires E.164.
    // If not already starting with +, add +91 for India.
    String formattedPhone = phoneNumber;
    if (!formattedPhone.startsWith('+')) {
      formattedPhone = '+91$formattedPhone';
    }

    final requestParam = {
      'phone': formattedPhone,
      'password': password,
    };
    try {
      final response = await DioHelper.postData(url: ApiConfig.loginEP, data: requestParam);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final loginResponse = LoginResponse.fromJson(response.data);
        if (loginResponse.success == true && loginResponse.data != null) {
          await SharedPreferenceUtil.saveUserData(userData: loginResponse.data);
          await SharedPreferenceUtil.putValue(kPrefIsLogin, true);
          await SharedPreferenceUtil.putValue(kPrefDeviceToken, loginResponse.data?.accessToken ?? '');
          showMessage(message: loginResponse.message ?? 'Login successful', type: 'success');
          emit(SuccessState());
        } else {
           final message = loginResponse.message ?? 'Login failed';
           showMessage(message: message);
           emit(ErrorState(message: message));
        }
      } else {
        final message = response.data is Map<String, dynamic>
            ? (response.data['message']?.toString() ?? response.data['detail']?.toString() ?? 'Login failed')
            : 'Login failed';
        showMessage(message: message);
        emit(ErrorState(message: message));
      }
    } catch (error) {
      showMessage(message: error.toString());
      emit(ErrorState(message: error.toString()));
    }
  }

  @override
  Future<void> close() {
    mobileNumberController.dispose();
    passwordController.dispose();
    return super.close();
  }
}