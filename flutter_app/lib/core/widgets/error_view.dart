import 'package:flutter/material.dart';

import '../utils/extensions/context_extensions.dart';
import 'app_button.dart';

/// حالة الـFailure الموحّدة، مع زرار "حاول تاني" اختياري. الرسالة لازم
/// تيجي بروح قاع الهامور من الـCubit (القسم 1.6/19) — الـwidget ده بس
/// بيعرضها، مبيقررش محتواها.
class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.message,
    super.key,
    this.onRetry,
  });

  final String message;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sentiment_dissatisfied_outlined, size: 48),
            const SizedBox(height: 16),
            Text(
              message,
              style: context.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 20),
              AppButton(label: context.l10n.genericRetry, onPressed: onRetry),
            ],
          ],
        ),
      ),
    );
  }
}
