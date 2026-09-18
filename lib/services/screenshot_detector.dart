import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Detects system screenshots via native EventChannel (iOS + Android).
class ScreenshotDetector {
  ScreenshotDetector._();

  static const String _channelName = 'screenshot_detector';
  static const EventChannel _channel = EventChannel(_channelName);

  static StreamController<String>? _controller;
  static StreamSubscription<dynamic>? _nativeSubscription;
  static bool _channelBound = false;
  static bool _initComplete = false;

  /// Initialise permissions (Android) and bind the native event channel.
  /// Safe to call multiple times.
  static Future<void> init() async {
    if (_initComplete && _channelBound) return;

    _controller ??= StreamController<String>.broadcast(
      onListen: () => debugPrint('[ScreenshotDetector] listener attached'),
    );

    await _ensureAndroidPermissions();
    _bindNativeChannel();
    _initComplete = true;
  }

  /// Android 13 and below need media access for MediaStore-based detection.
  /// Android 14+ uses [ScreenCaptureCallback] (no storage permission).
  static Future<void> _ensureAndroidPermissions() async {
    if (!Platform.isAndroid) return;

    try {
      final photos = await Permission.photos.status;
      if (photos.isGranted || photos.isLimited) return;

      final storage = await Permission.storage.status;
      if (storage.isGranted) return;

      final photosResult = await Permission.photos.request();
      if (photosResult.isGranted || photosResult.isLimited) return;

      await Permission.storage.request();
    } catch (e) {
      debugPrint('[ScreenshotDetector] permission request failed: $e');
    }
  }

  static void _bindNativeChannel() {
    if (_channelBound) return;

    try {
      _nativeSubscription?.cancel();
      _nativeSubscription = _channel.receiveBroadcastStream().listen(
        (dynamic event) {
          if (event != null) {
            final message = event.toString();
            debugPrint('[ScreenshotDetector] event: $message');
            if (!_controller!.isClosed) {
              _controller!.add(message);
            }
          }
        },
        onError: (Object error, StackTrace stack) {
          debugPrint('[ScreenshotDetector] channel error: $error');
          _channelBound = false;
          // Retry binding after a short delay (engine may not be ready).
          Future<void>.delayed(const Duration(seconds: 2), () {
            if (!_controller!.isClosed) _bindNativeChannel();
          });
        },
        cancelOnError: false,
      );
      _channelBound = true;
      debugPrint('[ScreenshotDetector] native channel bound');
    } on MissingPluginException catch (e) {
      debugPrint('[ScreenshotDetector] plugin missing: $e');
    } catch (e) {
      debugPrint('[ScreenshotDetector] bind failed: $e');
    }
  }

  /// Broadcast stream of screenshot events.
  static Stream<String> get stream {
    if (!_initComplete) {
      init();
    }
    return _controller!.stream;
  }

  /// Subscribe after [init] completes (use from product detail / reel screens).
  static Future<StreamSubscription<String>> listen(
    void Function(String event) onData, {
    void Function(Object error)? onError,
  }) async {
    await init();
    return stream.listen(
      onData,
      onError: onError ??
          (Object error) {
            debugPrint('[ScreenshotDetector] listener error: $error');
          },
      cancelOnError: false,
    );
  }

  static void dispose() {
    _nativeSubscription?.cancel();
    _nativeSubscription = null;
    _controller?.close();
    _controller = null;
    _channelBound = false;
    _initComplete = false;
  }
}
