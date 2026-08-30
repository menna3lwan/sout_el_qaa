import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sout_el_qaa/core/locale/app_locale_cubit.dart';
import 'package:sout_el_qaa/core/locale/locale_settings_store.dart';

class MockLocaleSettingsStore extends Mock implements LocaleSettingsStore {}

void main() {
  late MockLocaleSettingsStore store;

  setUp(() {
    store = MockLocaleSettingsStore();
  });

  test('starts on Arabic so existing users keep the previous default', () {
    expect(AppLocaleCubit(store).state, const Locale('ar'));
  });

  blocTest<AppLocaleCubit, Locale>(
    'hydrate emits the persisted locale when it is supported',
    build: () {
      when(() => store.readLocaleCode()).thenAnswer((_) async => 'de');
      return AppLocaleCubit(store);
    },
    act: (cubit) => cubit.hydrate(),
    expect: () => [const Locale('de')],
  );

  blocTest<AppLocaleCubit, Locale>(
    'hydrate stays on Arabic when nothing is saved',
    build: () {
      when(() => store.readLocaleCode()).thenAnswer((_) async => null);
      return AppLocaleCubit(store);
    },
    act: (cubit) => cubit.hydrate(),
    expect: () => <Locale>[],
  );

  blocTest<AppLocaleCubit, Locale>(
    'setLocale emits and persists a supported language',
    build: () {
      when(() => store.writeLocaleCode(any())).thenAnswer((_) async {});
      return AppLocaleCubit(store);
    },
    act: (cubit) => cubit.setLocale(const Locale('en')),
    expect: () => [const Locale('en')],
    verify: (_) {
      verify(() => store.writeLocaleCode('en')).called(1);
    },
  );

  blocTest<AppLocaleCubit, Locale>(
    'setLocale ignores an unsupported language',
    build: () => AppLocaleCubit(store),
    act: (cubit) => cubit.setLocale(const Locale('fr')),
    expect: () => <Locale>[],
    verify: (_) {
      verifyNever(() => store.writeLocaleCode(any()));
    },
  );
}
