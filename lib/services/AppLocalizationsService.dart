import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizationsService {
  final Locale locale;

  AppLocalizationsService(this.locale);

  static AppLocalizationsService of(BuildContext context) =>
      Localizations.of<AppLocalizationsService>(
          context, AppLocalizationsService);

  static const LocalizationsDelegate<AppLocalizationsService> delegate =
      _AppLocalizationsServiceDelegate();

  Map<String, String> _localizedStrings;

  Future<AppLocalizationsService> load() async {
    String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');

    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });

    return this;
  }

  String translate(String key) => _localizedStrings[key];
}

class _AppLocalizationsServiceDelegate
    extends LocalizationsDelegate<AppLocalizationsService> {
  const _AppLocalizationsServiceDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizationsService> load(Locale locale) async {
    AppLocalizationsService localizations = new AppLocalizationsService(locale);
    await localizations.load();

    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsServiceDelegate old) => false;
}
