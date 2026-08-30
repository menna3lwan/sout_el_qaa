import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';

/// Unified input field showing validation messages inline, next to the field rather than in a
/// snackbar.
class AppTextField extends StatelessWidget {
  const AppTextField({
    required this.label,
    super.key,
    this.controller,
    this.errorText,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
    this.onChanged,
    this.textInputAction,
  });

  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    final isMultiline = !obscureText && maxLines > 1;
    final radius = BorderRadius.circular(
      isMultiline ? AppSpacing.radiusLg : AppSpacing.radiusPill,
    );

    OutlineInputBorder border(Color color, {double width = 1.5}) =>
        OutlineInputBorder(
          borderRadius: radius,
          borderSide: BorderSide(color: color, width: width),
        );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: obscureText ? 1 : maxLines,
      onChanged: onChanged,
      textInputAction: textInputAction,
      textAlignVertical:
          isMultiline ? TextAlignVertical.top : TextAlignVertical.center,
      decoration: InputDecoration(
        labelText: label,
        hintText: hintText,
        errorText: errorText,
        alignLabelWithHint: isMultiline,
        border: border(AppColors.borderFigmaDefault),
        enabledBorder: border(AppColors.borderFigmaDefault),
        focusedBorder: border(AppColors.borderFigmaFocus, width: 2),
        errorBorder: border(AppColors.error),
        focusedErrorBorder: border(AppColors.error, width: 2),
      ),
    );
  }
}
