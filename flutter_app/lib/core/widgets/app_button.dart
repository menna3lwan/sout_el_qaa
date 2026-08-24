import 'package:flutter/material.dart';

/// زرار أساسي موحّد — بيغلف [ElevatedButton] بدعم loading state مدمج، عشان
/// كل شاشة فورم (Login, Create Complaint...) متكررش نفس منطق "عطّل الزرار
/// وأظهر spinner وقت الإرسال" بنفسها.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final canPress = isEnabled && !isLoading && onPressed != null;

    return ElevatedButton(
      onPressed: canPress ? onPressed : null,
      child: isLoading
          ? const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(strokeWidth: 2.4),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );
  }
}
