import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sout_el_qaa/core/utils/message_key_resolver.dart';
import 'package:sout_el_qaa/l10n/app_localizations.dart';

void main() {
  testWidgets('maps known keys in English', (tester) async {
    late String resolved;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            resolved = resolveMessageKey(context, 'validationInvalidEmail');
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved, "That email doesn't look right");
  });

  testWidgets('passes unknown Arabic server text through in Arabic',
      (tester) async {
    const serverText = 'الإيميل ده مستخدم بالفعل يا جار';
    late String resolved;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('ar'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            resolved = resolveMessageKey(context, serverText);
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved, serverText);
  });

  testWidgets('hides unknown Arabic server text in English', (tester) async {
    late String resolved;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('en'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            resolved = resolveMessageKey(
              context,
              'الإيميل ده مستخدم بالفعل يا جار',
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved, "We've got a connection problem... try again, citizen!");
  });

  testWidgets('hides unknown Arabic server text in German', (tester) async {
    late String resolved;
    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: Builder(
          builder: (context) {
            resolved = resolveMessageKey(
              context,
              'الإيميل ده مستخدم بالفعل يا جار',
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    expect(resolved, 'Verbindungsproblem... bitte noch einmal versuchen!');
  });
}
