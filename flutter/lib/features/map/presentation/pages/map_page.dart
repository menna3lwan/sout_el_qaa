import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي هيتم جوه `feature/plankton-map`. الشاشة دي
/// أصلًا مش موجودة في الـFigma (node 33:351 فارغ تمامًا — القسم 3.7)،
/// فالتصميم هيكون منّا [P3] بنفس لغة باقي الشاشات.
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
