import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation lands in feature/plankton-map; this screen doesn't exist in Figma at all (node 33:351 is completely empty, PLAN.md section 3.7), so the design will be ours [P3], matching the other screens' style.
class MapPage extends StatelessWidget {
  const MapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.navMap,
      icon: Icons.map_outlined,
    );
  }
}
