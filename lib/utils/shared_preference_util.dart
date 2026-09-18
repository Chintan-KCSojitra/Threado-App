import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:thredo/model/login_response.dart';

import '../res/strings.dart';

class SharedPreferenceUtil {
  static SharedPreferenceUtil? _singleton;
  static SharedPreferences? _prefs;
  static const _secureStorage = FlutterSecureStorage();
  static String? _secureUserDataCache;
  static String? _secureDeviceTokenCache;

  static Future<SharedPreferenceUtil?> getInstance() async {
    if (_singleton == null) {
      var singleton = SharedPreferenceUtil._();
      await singleton._init();
      _singleton = singleton;
    }
    return _singleton;
  }

  SharedPreferenceUtil._();

  Future _init() async {
    _prefs = await SharedPreferences.getInstance();
    
    // Load from secure storage
    _secureUserDataCache = await _secureStorage.read(key: kPrefUserData);
    _secureDeviceTokenCache = await _secureStorage.read(key: kPrefDeviceToken);
    
    // Silent migration from SharedPreferences to secure storage
    if (_secureUserDataCache == null || _secureUserDataCache!.isEmpty) {
      final legacyData = _prefs?.getString(kPrefUserData);
      if (legacyData != null && legacyData.isNotEmpty) {
        await _secureStorage.write(key: kPrefUserData, value: legacyData);
        _secureUserDataCache = legacyData;
        await _prefs?.remove(kPrefUserData);
      }
    }

    if (_secureDeviceTokenCache == null || _secureDeviceTokenCache!.isEmpty) {
      final legacyToken = _prefs?.getString(kPrefDeviceToken);
      if (legacyToken != null && legacyToken.isNotEmpty) {
        await _secureStorage.write(key: kPrefDeviceToken, value: legacyToken);
        _secureDeviceTokenCache = legacyToken;
        await _prefs?.remove(kPrefDeviceToken);
      }
    }
  }

  static String? encode(Object? value) => value == null ? '' : json.encode(value);

  static dynamic decode(String? value) => value == null || value.isEmpty ? null : json.decode(value);

  static Future<bool> putValue<T>(String key, T value) async {
    if (key == kPrefDeviceToken) {
      final tokenStr = value as String;
      _secureDeviceTokenCache = tokenStr;
      await _secureStorage.write(key: kPrefDeviceToken, value: tokenStr);
      await _prefs?.remove(kPrefDeviceToken);
      return true;
    }
    if (_prefs == null) return false;
    if (T == String) {
      return _prefs!.setString(key, value as String);
    } else if (T == bool) {
      return _prefs!.setBool(key, value as bool);
    } else if (T == int) {
      return _prefs!.setInt(key, value as int);
    } else if (T == double) {
      return _prefs!.setDouble(key, value as double);
    }
    return false;
  }

  static String getString(String key, {String defValue = ''}) {
    if (key == kPrefDeviceToken) {
      return _secureDeviceTokenCache ?? defValue;
    }
    return _prefs?.getString(key) ?? defValue;
  }

  static bool getBool(String key, {bool defValue = false}) => _prefs?.getBool(key) ?? defValue;

  static int getInt(String key, {int defValue = 0}) => _prefs?.getInt(key) ?? defValue;

  static double getDouble(String key, {double defValue = 0.0}) => _prefs?.getDouble(key) ?? defValue;

  static List<String> getStringList(String key, {List<String> defValue = const []}) => _prefs?.getStringList(key) ?? defValue;

  static dynamic getDynamic(String key, {Object? defValue}) => _prefs?.get(key) ?? defValue;

  static bool? haveKey(String key) => _prefs?.getKeys().contains(key);

  static Set<String>? getKeys() => _prefs?.getKeys();

  static bool isInitialized() => _prefs != null;

  static Future<bool> clearData() async {
    _secureUserDataCache = null;
    _secureDeviceTokenCache = null;
    await _secureStorage.delete(key: kPrefUserData);
    await _secureStorage.delete(key: kPrefDeviceToken);
    return (await SharedPreferences.getInstance()).clear();
  }

  /*-------------------------------------------*/
  /* static LoginData? getUserData() {
    final user = getString(kPrefUserData);
    return LoginData.fromJson(jsonDecode(user));
  }*/

  static LoginData? getUserData() {
    final user = _secureUserDataCache;
    if (user == null || user.isEmpty) {
      return null;
    }
    try {
      return LoginData.fromJson(jsonDecode(user));
    } catch (e) {
      return null;
    }
  }

  static Future<bool> saveUserData({LoginData? userData}) async {
    final jsonStr = jsonEncode(userData?.toJson());
    _secureUserDataCache = jsonStr;
    await _secureStorage.write(key: kPrefUserData, value: jsonStr);
    return true;
  }

  static Future<bool> removeUserData() async {
    _secureUserDataCache = null;
    await _secureStorage.delete(key: kPrefUserData);
    return true;
  }
}
