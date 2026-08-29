import 'package:flutter/material.dart';

import '../../../../common/widgets/placeholder_screen.dart';
import '../../../../core/utils/extensions/context_extensions.dart';

/// Visual placeholder only — "Checking Auth → Redirect" logic (PLAN.md section 3.1) deliberately lives in core/router/app_router.dart (GoRouter.redirect), not here, so this widget stays presentation-only with no direct I/O ("no business logic inside widgets", PLAN.md section 1.2), and so splash/auth stay fully empty until feature/patrick-auth like every other unimplemented feature.
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
