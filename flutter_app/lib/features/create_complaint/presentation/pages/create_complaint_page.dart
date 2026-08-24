import 'package:flutter/material.dart';

import '../../../../core/utils/extensions/context_extensions.dart';
import '../../../../common/widgets/placeholder_screen.dart';

/// Placeholder — التنفيذ الفعلي (فورم 3 مراحل [A5]، رفع وسائط، severity،
/// ربط بالخريطة) هيتم جوه `feature/sandy-create-complaint` مطابقًا لـFigma
/// node 33:210 (القسم 3.6).
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
