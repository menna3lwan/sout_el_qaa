import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation (3-stage form [A5], media upload, severity, map linking) lands in feature/sandy-create-complaint, matching Figma node 33:210 (PLAN.md section 3.6).
class CreateComplaintPage extends StatelessWidget {
  const CreateComplaintPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.navAdd,
      icon: Icons.add_circle_outline,
    );
  }
}
