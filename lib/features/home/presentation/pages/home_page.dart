import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../shared_widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي (feed, categories, recent activity) هيتم
/// جوه `feature/squidward-home` مطابقًا لـFigma node 33:21 (القسم 3.3).
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
