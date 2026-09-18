import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:thredo/app_config.dart';
import 'package:thredo/res/strings.dart';
import 'package:thredo/utils/shared_preference_util.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(_readInitial()) {
    AppConfig.defaultLanguage = state.languageCode;
  }

  static Locale _readInitial() {
    final raw = SharedPreferenceUtil.getString(kPrefAppLocaleCode);
    if (raw.isEmpty) return const Locale('en');
    final normalized = raw.replaceAll('-', '_');
    final parts = normalized.split('_');
    if (parts.length >= 2 && parts[1].isNotEmpty) {
      return Locale(parts[0], parts[1].toUpperCase());
    }
    return Locale(parts[0]);
  }

  Future<void> setLocale(Locale locale) async {
    final tag = locale.countryCode != null && locale.countryCode!.isNotEmpty
        ? '${locale.languageCode}_${locale.countryCode}'
        : locale.languageCode;
    await SharedPreferenceUtil.putValue<String>(kPrefAppLocaleCode, tag);
    AppConfig.defaultLanguage = locale.languageCode;
    emit(locale);
  }

  static Future<void> setLanguageOnboardingComplete() async {
    await SharedPreferenceUtil.putValue<bool>(kPrefLanguageOnboardingComplete, true);
  }

  static bool isLanguageOnboardingComplete() =>
      SharedPreferenceUtil.getBool(kPrefLanguageOnboardingComplete);
}
