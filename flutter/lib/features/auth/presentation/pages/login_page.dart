import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation (form, validation, session persistence) lands in feature/patrick-auth; this screen is [C3]: designed by us since Figma has no Login/Register design (PLAN.md section 3.2).
class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.authLoginTitle,
      icon: Icons.login_outlined,
    );
  }
}
