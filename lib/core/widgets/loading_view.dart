import 'package:flutter/material.dart';

import '../utils/extensions/context_extensions.dart';

/// حالة الـLoading الموحّدة — بتتستخدم في كل Cubit state من نوع Loading،
/// بدل ما كل شاشة تبني spinner بنفسها (القسم 6: نموذج الحالات الموحّد).
class LoadingView extends StatelessWidget {
  const LoadingView({super.key, this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(
            message ?? context.l10n.genericLoading,
            style: context.textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
