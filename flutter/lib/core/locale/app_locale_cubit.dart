import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'locale_settings_store.dart';

/// Holds the active [Locale] and writes it to [LocaleSettingsStore]. Defaults to Arabic so
/// existing users keep the previous hardcoded-`ar` behavior until they pick another language.
class AppLocaleCubit extends Cubit<Locale> {
  AppLocaleCubit(this._store) : super(AppLocaleCubit.defaultLocale);

  static const defaultLocale = Locale('ar');

  static const supportedLocales = [
    Locale('ar'),
    Locale('en'),
    Locale('de'),
  ];

  final LocaleSettingsStore _store;

  Future<void> hydrate() async {
    final code = await _store.readLocaleCode();
    for (final locale in supportedLocales) {
      if (locale.languageCode == code) {
        emit(locale);
        return;
      }
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (!supportedLocales
        .any((supported) => supported.languageCode == locale.languageCode)) {
      return;
    }
    emit(Locale(locale.languageCode));
    await _store.writeLocaleCode(locale.languageCode);
  }
}
