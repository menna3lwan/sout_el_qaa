import 'package:flutter/material.dart';

import '../../core/utils/extensions/context_extensions.dart';

/// شاشة placeholder موحّدة لأي feature لسه ما اتنفذتش (foundation branch
/// فقط). كل الـfeature branches الجاية (patrick-auth, squidward-home,
/// plankton-map, mrkrabs-complaints, sandy-profile...) هتستبدل الصفحة اللي
/// بتستخدم الـwidget ده بتنفيذها الفعلي المطابق للـFigma.
///
/// **ملحوظة معمارية:** الـwidget ده جوه `shared_widgets/` مش `core/widgets/`
/// عمدًا — لأنه مرتبط بمفهوم "صفحة feature لسه ماتنفذتش" (سياق منتج/تنفيذي)
/// مش widget UI عام بلا سياق (انظر القسم 1.10 من الـplan: Core vs Feature).
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
