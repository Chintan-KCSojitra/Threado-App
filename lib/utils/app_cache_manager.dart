import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// A wrapper around [JsonCacheInfoRepository] that catches corrupted or empty JSON metadata
/// files (`FormatException`) and automatically purges them to prevent app startup / cache crashes.
class SafeJsonCacheInfoRepository implements CacheInfoRepository {
  final String databaseName;
  late JsonCacheInfoRepository _delegate;

  SafeJsonCacheInfoRepository({required this.databaseName}) {
    _delegate = JsonCacheInfoRepository(databaseName: databaseName);
  }

  Future<File?> _getCacheFile() async {
    try {
      final directory = await getApplicationSupportDirectory();
      return File(p.join(directory.path, '$databaseName.json'));
    } catch (_) {
      return null;
    }
  }

  Future<void> _sanitizeCacheFile() async {
    try {
      final file = await _getCacheFile();
      if (file != null && await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isEmpty) {
          await file.delete();
        } else {
          try {
            jsonDecode(content);
          } catch (e) {
            debugPrint('SafeJsonCacheInfoRepository: Corrupt JSON detected ($e), deleting cache file.');
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('SafeJsonCacheInfoRepository: Error sanitizing cache file: $e');
    }
  }

  Future<T> _runSafely<T>(Future<T> Function() action, T fallback) async {
    try {
      return await action();
    } on FormatException catch (e) {
      debugPrint('SafeJsonCacheInfoRepository FormatException caught: $e. Resetting cache repository.');
      await _sanitizeCacheFile();
      _delegate = JsonCacheInfoRepository(databaseName: databaseName);
      try {
        await _delegate.open();
        return await action();
      } catch (retryError) {
        debugPrint('SafeJsonCacheInfoRepository retry failed: $retryError');
        return fallback;
      }
    } catch (e) {
      debugPrint('SafeJsonCacheInfoRepository error caught: $e');
      return fallback;
    }
  }

  @override
  Future<bool> open() async {
    await _sanitizeCacheFile();
    return _runSafely(() => _delegate.open(), false);
  }

  @override
  Future<bool> exists() async {
    return _runSafely(() => _delegate.exists(), false);
  }

  @override
  Future<CacheObject?> get(String key) async {
    return _runSafely(() => _delegate.get(key), null);
  }

  @override
  Future<List<CacheObject>> getAllObjects() async {
    return _runSafely(() => _delegate.getAllObjects(), <CacheObject>[]);
  }

  @override
  Future<CacheObject> insert(CacheObject cacheObject, {bool setTouchedToNow = true}) async {
    return _runSafely(() => _delegate.insert(cacheObject, setTouchedToNow: setTouchedToNow), cacheObject);
  }

  @override
  Future<int> update(CacheObject cacheObject, {bool setTouchedToNow = true}) async {
    return _runSafely(() => _delegate.update(cacheObject, setTouchedToNow: setTouchedToNow), 0);
  }

  @override
  Future<dynamic> updateOrInsert(CacheObject cacheObject) async {
    return _runSafely<dynamic>(() => _delegate.updateOrInsert(cacheObject), cacheObject);
  }

  @override
  Future<int> delete(int id) async {
    return _runSafely(() => _delegate.delete(id), 0);
  }

  @override
  Future<int> deleteAll(Iterable<int> ids) async {
    return _runSafely(() => _delegate.deleteAll(ids), 0);
  }

  @override
  Future<void> deleteDataFile() async {
    await _runSafely(() async {
      await _delegate.deleteDataFile();
    }, null);
  }

  @override
  Future<bool> close() async {
    return _runSafely(() => _delegate.close(), true);
  }

  @override
  Future<List<CacheObject>> getObjectsOverCapacity(int capacity) async {
    return _runSafely(() => _delegate.getObjectsOverCapacity(capacity), <CacheObject>[]);
  }

  @override
  Future<List<CacheObject>> getOldObjects(Duration maxAge) async {
    return _runSafely(() => _delegate.getOldObjects(maxAge), <CacheObject>[]);
  }
}

class AppCacheManager {
  static const key = 'customCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 30),
      maxNrOfCacheObjects: 1000,
      repo: SafeJsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}
