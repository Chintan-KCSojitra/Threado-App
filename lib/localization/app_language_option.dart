import 'package:flutter/material.dart';

/// Display metadata for languages shipped in [lib/l10n]. Keep in sync with ARB locales.
class AppLanguageOption {
  const AppLanguageOption({
    required this.locale,
    required this.labelNative,
    required this.labelEnglish,
  });

  final Locale locale;
  final String labelNative;
  final String labelEnglish;
}

const List<AppLanguageOption> kAppLanguageOptions = [
  AppLanguageOption(
    locale: Locale('en'),
    labelNative: 'English',
    labelEnglish: 'English',
  ),
  AppLanguageOption(
    locale: Locale('hi'),
    labelNative: 'हिन्दी',
    labelEnglish: 'Hindi',
  ),
  AppLanguageOption(
    locale: Locale('gu'),
    labelNative: 'ગુજરાતી',
    labelEnglish: 'Gujarati',
  ),
  AppLanguageOption(
    locale: Locale('ta'),
    labelNative: 'தமிழ்',
    labelEnglish: 'Tamil',
  ),
  AppLanguageOption(
    locale: Locale('te'),
    labelNative: 'తెలుగు',
    labelEnglish: 'Telugu',
  ),
  AppLanguageOption(
    locale: Locale('mr'),
    labelNative: 'मराठी',
    labelEnglish: 'Marathi',
  ),
  AppLanguageOption(
    locale: Locale('bn'),
    labelNative: 'বাংলা',
    labelEnglish: 'Bengali',
  ),
  AppLanguageOption(
    locale: Locale('kn'),
    labelNative: 'ಕನ್ನಡ',
    labelEnglish: 'Kannada',
  ),
  AppLanguageOption(
    locale: Locale('ml'),
    labelNative: 'മലയാളം',
    labelEnglish: 'Malayalam',
  ),
  AppLanguageOption(
    locale: Locale('pa'),
    labelNative: 'ਪੰਜਾਬੀ',
    labelEnglish: 'Punjabi',
  ),
];

int indexForLocale(Locale locale) {
  final i = kAppLanguageOptions.indexWhere(
    (o) => o.locale.languageCode == locale.languageCode,
  );
  return i >= 0 ? i : 0;
}
