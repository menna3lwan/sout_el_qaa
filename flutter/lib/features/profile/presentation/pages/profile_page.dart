import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation lands in feature/sandy-profile, matching Figma node 33:794 (PLAN.md section 3.10).
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.navProfile,
      icon: Icons.person_outline,
    );
  }
}
