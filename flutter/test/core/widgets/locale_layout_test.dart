import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sout_el_qaa/core/widgets/bidi_aware_text.dart';
import 'package:sout_el_qaa/core/widgets/settings_menu_item.dart';
import 'package:sout_el_qaa/l10n/app_localizations.dart';

void main() {
  Widget wrap({
    required Locale locale,
    required Widget child,
  }) {
    return MaterialApp(
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Scaffold(body: child),
    );
  }

  testWidgets('settings chevron points toward the row in RTL', (tester) async {
    await tester.pumpWidget(
      wrap(
        locale: const Locale('ar'),
        child: SettingsMenuItem(label: 'إعدادات', onTap: () {}),
      ),
    );
    final icon = tester.widget<Icon>(find.byType(Icon).first);
    expect(icon.icon?.codePoint, 0xe5cb);
  });

  testWidgets('settings chevron points toward the row in LTR', (tester) async {
    await tester.pumpWidget(
      wrap(
        locale: const Locale('en'),
        child: SettingsMenuItem(label: 'Settings', onTap: () {}),
      ),
    );
    final icon = tester.widget<Icon>(find.byType(Icon).first);
    expect(icon.icon?.codePoint, 0xe5cc);
  });

  testWidgets('BidiAwareText isolates an English title as LTR', (tester) async {
    await tester.pumpWidget(
      wrap(
        locale: const Locale('ar'),
        child: const BidiAwareText('Broken streetlight on Coral Ave'),
      ),
    );
    final text = tester.widget<Text>(find.byType(Text));
    expect(text.textDirection, TextDirection.ltr);
  });

  testWidgets('long German compounds do not overflow a narrow column',
      (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      wrap(
        locale: const Locale('de'),
        child: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return SizedBox(
              width: 180,
              child: Column(
                children: [
                  Text(l10n.homeRecentActivityHeading),
                  Text(l10n.homeCategoriesHeading),
                  Text(l10n.createComplaintReviewTitle),
                  Text(l10n.profileNextRankCaption(120, 'Meeresretter')),
                  Text(l10n.notificationsMarkAllRead),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('short Arabic labels still render in a narrow column',
      (tester) async {
    late AppLocalizations l10n;
    await tester.pumpWidget(
      wrap(
        locale: const Locale('ar'),
        child: Builder(
          builder: (context) {
            l10n = AppLocalizations.of(context);
            return SizedBox(
              width: 180,
              child: Column(
                children: [
                  Text(l10n.navHome),
                  Text(l10n.homeUrgentBadge),
                  Text(l10n.genericSave),
                ],
              ),
            );
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}
