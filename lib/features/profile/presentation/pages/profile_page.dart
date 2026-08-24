import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../shared_widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي هيتم جوه `feature/sandy-profile` مطابقًا
/// لـFigma node 33:794 (القسم 3.10).
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
