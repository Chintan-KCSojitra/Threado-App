import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:thredo/api/dio_helper.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/model/login_response.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/utils/helper.dart';
import 'package:thredo/utils/shared_preference_util.dart';
import 'package:thredo/view/otpVerification/cubit/otp_verification_state.dart';

class OtpVerificationCubit extends Cubit<OtpVerificationState> {
  OtpVerificationCubit({required this.phoneNumber}) : super(OtpVerificationStateData()) {
    _startResendTimer();
  }

  final String phoneNumber;
  final PinInputController otpController = PinInputController();
  Timer? _timer;

  OtpVerificationStateData get _stateData => state as OtpVerificationStateData;

  void _startResendTimer() {
    _timer?.cancel();
    emit(_stateData.copyWith(secondsLeft: 60));
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      final seconds = _stateData.secondsLeft;
      if (seconds <= 0) {
        timer.cancel();
        return;
      }
      emit(_stateData.copyWith(secondsLeft: seconds - 1));
    });
  }

  Future<void> resendOtp() async {
    if (!_stateData.canResend) return;
    emit(_stateData.copyWith(isResending: true));
    try {
      final response = await DioHelper.postData(url: ApiConfig.sendOtpEP, data: {'phone': phoneNumber});
      if (response.statusCode == 200) {
        showMessage(message: 'OTP sent successfully', type: 'success');
        emit(_stateData.copyWith(isResending: false));
        _startResendTimer();
      } else {
        final message = response.data is Map<String, dynamic>
            ? (response.data['message']?.toString() ?? 'Failed to resend OTP')
            : 'Failed to resend OTP';
        showMessage(message: message);
        emit(_stateData.copyWith(isResending: false));
      }
    } catch (error) {
      showMessage(message: error.toString());
      emit(_stateData.copyWith(isResending: false));
    }
  }

  Future<bool> verifyOtp() async {
    final otp = otpController.text.trim();
    if (otp.length < 4) {
      showMessage(message: 'Please enter valid OTP');
      return false;
    }

    emit(_stateData.copyWith(isVerifying: true));
    try {
      final response = await DioHelper.postData(url: ApiConfig.verifyOtpEP, data: {'phone': phoneNumber, 'otp': otp});

      if (response.statusCode == 200) {
        final loginResponse = LoginResponse.fromJson(response.data);
        if (loginResponse.success == true && loginResponse.data != null) {
          await SharedPreferenceUtil.saveUserData(userData: loginResponse.data);
          await SharedPreferenceUtil.putValue(kPrefIsLogin, true);
          await SharedPreferenceUtil.putValue(kPrefDeviceToken, loginResponse.data?.accessToken ?? '');
          showMessage(message: loginResponse.message ?? 'OTP verified', type: 'success');
          emit(_stateData.copyWith(isVerifying: false));
          return true;
        }

        final message = loginResponse.message ?? 'OTP verification failed';
        showMessage(message: message);
        emit(_stateData.copyWith(isVerifying: false));
        return false;
      }

      final message = response.data is Map<String, dynamic>
          ? (response.data['message']?.toString() ?? 'OTP verification failed')
          : 'OTP verification failed';
      showMessage(message: message);
      emit(_stateData.copyWith(isVerifying: false));
      return false;
    } catch (error) {
      showMessage(message: error.toString());
      emit(_stateData.copyWith(isVerifying: false));
      return false;
    }
  }

  String get resendTimerLabel {
    final seconds = _stateData.secondsLeft;
    final minutesPart = (seconds ~/ 60).toString().padLeft(2, '0');
    final secondsPart = (seconds % 60).toString().padLeft(2, '0');
    return '$minutesPart:$secondsPart';
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    otpController.dispose();
    return super.close();
  }
}
