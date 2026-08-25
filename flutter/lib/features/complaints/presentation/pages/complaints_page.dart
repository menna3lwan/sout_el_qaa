import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — real implementation (tabs, filtering, cards) lands in feature/mrkrabs-complaints, matching Figma node 33:663 (PLAN.md section 3.5); scope reminder (PLAN.md section 18): this screen owns only the list, not individual complaint details.
class ComplaintsPage extends StatelessWidget {
  const ComplaintsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlaceholderScreen(
      title: context.l10n.navComplaints,
      icon: Icons.report_outlined,
    );
  }
}
