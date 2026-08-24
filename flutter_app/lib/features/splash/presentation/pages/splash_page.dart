import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder بصري بس — منطق "Checking Auth → Redirect" (القسم 3.1) اتحط
/// عمدًا في `core/router/app_router.dart` (GoRouter.redirect) مش هنا، عشان
/// الـwidget يفضل presentation-only بلا I/O مباشر (قاعدة الـarchitecture:
/// "لا منطق أعمال جوه الـwidgets" — القسم 1.2)، وعشان `splash`/`auth`
/// الفعليين يفضلوا فاضيين تمامًا لحد `feature/patrick-auth` زي باقي
/// الـfeatures الغير منفذة، بدون استثناء غير مبرر.
class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.appTitle,
      icon: Icons.waves_outlined,
    );
  }
}
