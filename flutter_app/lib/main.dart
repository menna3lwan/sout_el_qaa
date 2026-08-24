import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'bootstrap.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() => bootstrap(() => const SoutElQaaApp());

/// جذر التطبيق. عربي فقط في الواجهة دلوقتي (بنية bilingual جاهزة — [C5])،
/// RTL بييجي تلقائيًا من `Locale('ar')` + `flutter_localizations` بدل ما
/// يتفرض يدويًا بـ`Directionality` منفصل.
class SoutElQaaApp extends StatelessWidget {
  const SoutElQaaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'صوت القاع',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      routerConfig: getIt<GoRouter>(),
      locale: const Locale('ar'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
    );
  }
}
