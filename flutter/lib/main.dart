import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'bootstrap.dart';
import 'core/di/injection.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

Future<void> main() => bootstrap(() => const SoutElQaaApp());

/// App root. Arabic-only UI for now (bilingual structure is ready, decision [C5]); RTL comes automatically from Locale('ar') + flutter_localizations instead of a separate manual Directionality.
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
