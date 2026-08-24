import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// أفاتار الموحّد — مقابل الـcomponent "SpongeBob Avatar" المؤكد وجوده في
/// كل الشاشات المصممة (Home, Complaint Details, إلخ — القسم 3 من الـplan).
///
/// **لسه بدون أصول شخصيات حقيقية** — مفيش صور افتراضية بتتضاف هنا لأنها
/// غير موجودة فعليًا (مبدأ عدم إضافة أصول وهمية، القسم 17). دلوقتي بيعرض:
/// صورة المستخدم لو موجود URL، وإلا حرف أول اسمه كـfallback بسيط. أشكال
/// الأفاتارات المتنوعة بروح شخصيات قاع الهامور هتتضاف مع `feature/patrick-auth`
/// (اختيار الأفاتار وقت التسجيل) لما الأصول الفعلية تتوفر.
class QaaAvatar extends StatelessWidget {
  const QaaAvatar({
    super.key,
    this.imageUrl,
    this.displayName,
    this.size = 44,
  });

  final String? imageUrl;
  final String? displayName;
  final double size;

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return ClipOval(
      child: SizedBox(
        width: size,
        height: size,
        child: hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) => _fallback(),
                errorWidget: (_, __, ___) => _fallback(),
              )
            : _fallback(),
      ),
    );
  }

  Widget _fallback() {
    final trimmedName = displayName?.trim() ?? '';
    final initial = trimmedName.isNotEmpty ? trimmedName.substring(0, 1) : '؟';

    return ColoredBox(
      color: AppColors.oceanBlueLight,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.textOnBrand,
            fontSize: size * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
