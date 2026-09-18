
import 'package:dio/dio.dart';

import '../app_config.dart';
import '../res/strings.dart';
import '../utils/app_utils.dart';
import '../utils/shared_preference_util.dart';

class AppInterceptor extends Interceptor {
  @override
  Future onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    _addCommonHeaders(options);
    return handler.next(options);
  }

  void _addCommonHeaders(RequestOptions options) {
    if (options.extra.containsKey('header')) {
      if (options.extra['header'] == true) {
        options.headers[ApiConfig.authorizationTokenKey] = _getAuthorizationToken();
      }
    }
    if (options.extra.containsKey('language')) {
      options.headers[ApiConfig.acceptLanguageKey] = AppConfig.defaultLanguage;
    }
  }

  String _getAuthorizationToken() {
    return "Bearer ${SharedPreferenceUtil.getString(kPrefDeviceToken)}";
  }

  @override
  Future onError(DioException err, ErrorInterceptorHandler handler) async {
    if (_shouldHandleError(err)) _handleError();
    return handler.next(err);
  }

  bool _shouldHandleError(DioException error) {
    return (error.type == DioExceptionType.badResponse && (error.response?.statusCode == 401)) ||
        (error.type == DioExceptionType.badResponse && (error.message == 'TokenExpired' || error.message == 'Authorization error'));
  }

  void _handleError() {
    AppUtils.instance.logout();
  }
}
