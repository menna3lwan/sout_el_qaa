import 'package:flutter/material.dart';

import '../../../../common/widgets/placeholder_screen.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Visual placeholder only — the "Checking Auth → Redirect" logic lives in
/// core/router/app_router.dart (GoRouter.redirect), not here, keeping this widget
/// presentation-only with no direct I/O.
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
