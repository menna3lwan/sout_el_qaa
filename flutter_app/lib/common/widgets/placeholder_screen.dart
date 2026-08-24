import 'package:flutter/material.dart';

import '../../core/utils/extensions/context_extensions.dart';

/// شاشة placeholder موحّدة لأي feature لسه ما اتنفذتش (foundation branch
/// فقط). كل الـfeature branches الجاية (patrick-auth, squidward-home,
/// plankton-map, mrkrabs-complaints, sandy-profile...) هتستبدل الصفحة اللي
/// بتستخدم الـwidget ده بتنفيذها الفعلي المطابق للـFigma.
///
/// **ملحوظة معمارية (بعد الـmonorepo restructure):** الـwidget ده جوه
/// `common/widgets/` مش `core/widgets/` عمدًا — الفرق بينهم مش "reusable
/// ولا لأ"، الفرق إن `core/` مخصص للحاجات الـinfrastructure-ish (DI, routing,
/// theme, error handling...) بينما `common/` مخصص لـUI مشتركة بين features
/// بس مش infrastructure ومش مرتبطة بـbusiness domain معين. `PlaceholderScreen`
/// بالظبط كده: مفهوم "صفحة لسه ماتنفذتش" عام تمامًا، مالوش أي علاقة بـ
/// domain الشكاوى أو أي feature بعينها — عكس `StatusBadge` مثلًا (اللي اتحط
/// جوه `features/complaints/` مش هنا، لأنه عارف تفاصيل domain الشكاوى).
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon ?? Icons.construction_outlined, size: 56),
              const SizedBox(height: 16),
              Text(
                context.l10n.placeholderScreenMessage,
                style: context.textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
