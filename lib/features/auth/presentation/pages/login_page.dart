import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../shared_widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي (فورم، validation، session persistence)
/// هيتم جوه `feature/patrick-auth`. الشاشة دي [C3]: هنصممها إحنا لأن
/// الـFigma مفيهوش تصميم أصلًا لـLogin/Register (القسم 3.2).
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
