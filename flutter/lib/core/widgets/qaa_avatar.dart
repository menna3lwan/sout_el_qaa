import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// أشكال الأفاتار الموجودة فعليًا في الـFigma — شكلين بصريين مختلفين
/// حسب مكان الاستخدام، مش تدرج حجم بسيط:
/// - [header]: أفاتار الـheader (44px) — خلفية زرقاء فاتحة، حدود صفراء رفيعة،
///   ظل ناعم.
/// - [profile]: أفاتار صفحة الملف الشخصي (128px) — خلفية سماوية فاتحة،
///   حدود كحلية غامقة أوضح، ظل "صلب" ثلاثي الأبعاد (4px 4px 0px، مش blur).
enum QaaAvatarVariant { header, profile }

/// أفاتار موحّد — مقابل الـcomponent "SpongeBob Avatar" المؤكد وجوده في كل
/// الشاشات المصممة (Home, Complaint Details, Profile، إلخ — القسم 3 من
/// الـplan). الشكلين البصريين ([QaaAvatarVariant]) مستخرجين من الـFigma
/// الحقيقي (24 أغسطس 2026)، مش مخترعين.
///
/// **لسه بدون أصول شخصيات حقيقية** — الصور الفعلية (SpongeBob وغيره) موجودة
/// في الـFigma لكن تعذّر تحميل الـbytes بتاعتها في هذه الجلسة (راجعي تقرير
/// الجلسة — مشكلة شبكة/allowlist، مش قرار تصميم). دلوقتي بيعرض: صورة
/// المستخدم لو موجود URL، وإلا حرف أول اسمه كـfallback بسيط.
class QaaAvatar extends StatelessWidget {
  const QaaAvatar({
    super.key,
    this.imageUrl,
    this.displayName,
    this.variant = QaaAvatarVariant.header,
    double? size,
  }) : _explicitSize = size;

  final String? imageUrl;
  final String? displayName;
  final QaaAvatarVariant variant;
  final double? _explicitSize;

  double get _size =>
      _explicitSize ?? (variant == QaaAvatarVariant.header ? 44 : 128);

  Color get _ringBackground => switch (variant) {
        QaaAvatarVariant.header => const Color(0xFF93C5FD),
        QaaAvatarVariant.profile => const Color(0xFFC6EEFF),
      };

  Color get _ringBorder => switch (variant) {
        QaaAvatarVariant.header => AppColors.avatarBorder,
        QaaAvatarVariant.profile => AppColors.profileAccent,
      };

  double get _borderWidth => variant == QaaAvatarVariant.header ? 2 : 2;

  List<BoxShadow> get _shadow => switch (variant) {
        QaaAvatarVariant.header => const [
            BoxShadow(
              color: Color(0x1A000000),
              offset: Offset(0, 4),
              blurRadius: 6,
            ),
          ],
        QaaAvatarVariant.profile => const [
            BoxShadow(
              // ظل "صلب" بدون blur — نفس نمط أزرار الـCTA
              color: Color(0x33002431),
              offset: Offset(4, 4),
            ),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Container(
      width: _size,
      height: _size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _ringBackground,
        border: Border.all(color: _ringBorder, width: _borderWidth),
        boxShadow: _shadow,
      ),
      child: ClipOval(
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
      color: _ringBackground,
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: AppColors.profileAccent,
            fontSize: _size * 0.4,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
