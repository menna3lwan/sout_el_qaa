import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../shared_widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي (تابات، فلترة، بطاقات) هيتم جوه
/// `feature/mrkrabs-complaints` مطابقًا لـFigma node 33:663 (القسم 3.5).
/// تذكير حدود المسؤولية (القسم 18 من الـplan): الشاشة دي هتملك القائمة
/// بس، مش تفاصيل شكوى فردية.
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
