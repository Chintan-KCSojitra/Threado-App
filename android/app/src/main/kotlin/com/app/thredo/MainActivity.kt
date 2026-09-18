package com.app.thredo

import android.app.Activity
import android.database.ContentObserver
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel

class MainActivity : FlutterActivity() {

    companion object {
        private const val TAG = "ScreenshotDetector"
        private const val CHANNEL = "screenshot_detector"
        private const val DEBOUNCE_MS = 900L
    }

    private var eventSink: EventChannel.EventSink? = null
    private var observer: ContentObserver? = null
    private var screenCaptureCallback: Activity.ScreenCaptureCallback? = null
    private var lastEmitMs = 0L
    private val mainHandler = Handler(Looper.getMainLooper())

    private val streamHandler = object : EventChannel.StreamHandler {
        override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
            eventSink = events
            startScreenshotDetection()
        }

        override fun onCancel(arguments: Any?) {
            stopScreenshotDetection()
            eventSink = null
        }
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        EventChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setStreamHandler(streamHandler)
    }

    private fun emitScreenshot(source: String) {
        val now = System.currentTimeMillis()
        if (now - lastEmitMs < DEBOUNCE_MS) return
        lastEmitMs = now
        mainHandler.post {
            try {
                eventSink?.success("Android Screenshot Captured")
                Log.d(TAG, "Screenshot detected via $source")
            } catch (e: Exception) {
                Log.e(TAG, "emit failed", e)
            }
        }
    }

    private fun startScreenshotDetection() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            try {
                val cb = Activity.ScreenCaptureCallback {
                    emitScreenshot("ScreenCaptureCallback")
                }
                registerScreenCaptureCallback(mainExecutor, cb)
                screenCaptureCallback = cb
                Log.d(TAG, "ScreenCaptureCallback registered (API 34+)")
            } catch (e: Exception) {
                Log.e(TAG, "ScreenCaptureCallback failed, falling back to MediaStore", e)
                startMediaStoreObserver()
            }
        } else {
            startMediaStoreObserver()
        }
    }

    private fun startMediaStoreObserver() {
        val obs = object : ContentObserver(mainHandler) {
            override fun onChange(selfChange: Boolean) {
                onChange(selfChange, null)
            }

            override fun onChange(selfChange: Boolean, uri: Uri?) {
                if (uri != null && isScreenshotUri(uri)) {
                    emitScreenshot("ContentObserver-uri")
                    return
                }
                // URI often lacks "screenshot" — check newest gallery item.
                mainHandler.postDelayed({ checkLatestScreenshotInMediaStore() }, 350)
            }
        }
        try {
            contentResolver.registerContentObserver(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                true,
                obs
            )
            observer = obs
            Log.d(TAG, "MediaStore ContentObserver registered")
        } catch (e: Exception) {
            Log.e(TAG, "ContentObserver registration failed", e)
        }
    }

    private fun isScreenshotUri(uri: Uri): Boolean {
        val s = uri.toString().lowercase()
        return s.contains("screenshot") ||
            s.contains("screen_shot") ||
            s.contains("screencapture") ||
            s.contains("screen-capture")
    }

    private fun checkLatestScreenshotInMediaStore() {
        try {
            val projection = arrayOf(
                MediaStore.Images.Media.DISPLAY_NAME,
                MediaStore.Images.Media.DATE_ADDED,
            )
            contentResolver.query(
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI,
                projection,
                null,
                null,
                "${MediaStore.Images.Media.DATE_ADDED} DESC"
            )?.use { cursor ->
                if (!cursor.moveToFirst()) return
                val name = cursor.getString(0)?.lowercase() ?: return
                val dateAdded = cursor.getLong(1)
                val ageSec = (System.currentTimeMillis() / 1000) - dateAdded
                if (ageSec > 8) return

                if (name.contains("screenshot") ||
                    name.contains("screen_shot") ||
                    name.contains("screencapture") ||
                    name.contains("screen-capture") ||
                    name.contains("scr_") ||
                    name.contains("capture")
                ) {
                    emitScreenshot("MediaStore-query")
                }
            }
        } catch (e: Exception) {
            Log.e(TAG, "MediaStore query failed", e)
        }
    }

    private fun stopScreenshotDetection() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            screenCaptureCallback?.let {
                try {
                    unregisterScreenCaptureCallback(it)
                } catch (e: Exception) {
                    Log.e(TAG, "unregister ScreenCaptureCallback failed", e)
                }
            }
            screenCaptureCallback = null
        }
        observer?.let {
            try {
                contentResolver.unregisterContentObserver(it)
            } catch (e: Exception) {
                Log.e(TAG, "unregister ContentObserver failed", e)
            }
        }
        observer = null
    }

    override fun onDestroy() {
        stopScreenshotDetection()
        super.onDestroy()
    }
}
