import 'package:dio/dio.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../app_config.dart';
import '../res/strings.dart';
import '../utils/shared_preference_util.dart';
import 'app_interceptor.dart';

class DioHelper {
  static final Dio dio = Dio()
    ..transformer = BackgroundTransformer()
    ..options = BaseOptions(
      connectTimeout: const Duration(seconds: 120),
      receiveTimeout: const Duration(seconds: 120),
      sendTimeout: const Duration(seconds: 120),
      baseUrl: ApiConfig.baseUrl,
    );

  static Future<void> init() async {
    final cacheStore = MemCacheStore(maxSize: 10485760, maxEntrySize: 1048576);
    final customCacheOptions = CacheOptions(
      store: cacheStore,
      policy: CachePolicy.refresh,
      priority: CachePriority.high,
      hitCacheOnErrorCodes: [401, 404],
      maxStale: const Duration(seconds: 10),
      hitCacheOnNetworkFailure: true,
    );

    final interceptors = <Interceptor>[
      AppInterceptor(),
      DioCacheInterceptor(options: customCacheOptions),
    ];
    if (kDebugMode) {
      interceptors.insertAll(0, [
        LogInterceptor(requestBody: true, responseBody: true),
        PrettyDioLogger(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseBody: true,
          responseHeader: false,
          error: true,
          compact: true,
          maxWidth: 100,
        ),
      ]);
    }
    dio.interceptors.addAll(interceptors);
  }

  /*-- Post Data ---------------------------------------------------*/
  static Future<Response<dynamic>> postData({
    required final String url,
    final Map<dynamic, dynamic>? data,
    final FormData? formData,
    final bool isHeader = false,
    final bool isLanguage = true,
    final bool enableCache = false,
    final Duration? cacheDuration,
    final CachePolicy cachePolicy = CachePolicy.refresh,
    final bool forceRefresh = false,
  }) => dio.post(
    url,
    data: formData ?? data,
    options: _requestOptions(
      isHeader: isHeader,
      isLanguage: isLanguage,
      enableCache: enableCache,
      cacheDuration: cacheDuration,
      cachePolicy: cachePolicy,
      forceRefresh: forceRefresh,
    ),
  );

  /*-- Delete Data ---------------------------------------------------*/

  static Future<Response<dynamic>> deleteData({
    required final String url,
    final Map<dynamic, dynamic>? data,
    final bool isHeader = false,
    final bool isLanguage = true,
    final bool enableCache = false,
    final Duration? cacheDuration,
    final CachePolicy cachePolicy = CachePolicy.refresh,
    final bool forceRefresh = false,
  }) => dio.delete(
    url,
    data: data,
    options: _requestOptions(
      isHeader: isHeader,
      isLanguage: isLanguage,
      enableCache: enableCache,
      cacheDuration: cacheDuration,
      cachePolicy: cachePolicy,
      forceRefresh: forceRefresh,
    ),
  );

  /*-- Put Data ---------------------------------------------------*/

  static Future<Response<dynamic>> putData({
    required final String url,
    required final Map<String, dynamic> data,
    final Map<String, dynamic>? query,
    final String? token,
  }) {
    final headers = {
      ApiConfig.acceptLanguageKey: AppConfig.defaultLanguage,
      'X-Authorization': token ?? '',
      'Content-Type': 'application/json',
    };
    dio.options.headers = headers;
    return dio.put(url, queryParameters: query, data: data);
  }

  static Future<Response<dynamic>> getData({
    required final String url,
    final Map<String, dynamic>? query,
    final bool isHeader = false,
    final bool enableCache = true,
    final Duration? cacheDuration,
    final CachePolicy cachePolicy = CachePolicy.refresh,
    final bool forceRefresh = false,
  }) => dio.get(
    url,
    queryParameters: query,
    options: _requestOptions(
      isHeader: isHeader,
      enableCache: enableCache,
      cacheDuration: cacheDuration,
      cachePolicy: cachePolicy,
      forceRefresh: forceRefresh,
    ),
  );

  static Map<String, dynamic>? headers;

  static Options _requestOptions({
    final bool isHeader = false,
    final bool isLanguage = false,
    final bool enableCache = true,
    final Duration? cacheDuration,
    final CachePolicy cachePolicy = CachePolicy.refresh,
    final bool forceRefresh = false,
  }) {
    final extraOptions = {
      'header': isHeader,
      if (isLanguage) 'language': true,
      if (enableCache) ...{
        'cache': true,
        'cacheDuration': cacheDuration ?? const Duration(seconds: 30),
        'cachePolicy': cachePolicy,
        'forceRefresh': forceRefresh,
      },
      'retryCount': 3,
      'retryDelay': const Duration(milliseconds: 500),
      'timeout': const Duration(seconds: 30),
    };
    if (isHeader) {
      headers = {
        ApiConfig.acceptLanguageKey: AppConfig.defaultLanguage,
        ApiConfig.authorizationTokenKey:
            'Bearer ${SharedPreferenceUtil.getString(kPrefDeviceToken)}',
        ApiConfig.contentTypeKey: ApiConfig.applicationJsonKey,
      };
    }
    return Options(
      extra: extraOptions,
      headers: isHeader ? headers : null,
      validateStatus: (final status) => status != null && status < 500,
      receiveTimeout: const Duration(seconds: 30),
      sendTimeout: const Duration(seconds: 30),
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      followRedirects: true,
      maxRedirects: 5,
    );
  }
}
