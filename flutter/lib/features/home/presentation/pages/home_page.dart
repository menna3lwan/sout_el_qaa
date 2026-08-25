import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation (feed, categories, recent activity) lands in feature/squidward-home, matching Figma node 33:21 (PLAN.md section 3.3).
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.navHome,
      icon: Icons.home_outlined,
    );
  }
}
