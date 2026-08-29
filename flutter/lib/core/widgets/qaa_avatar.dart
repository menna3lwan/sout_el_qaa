import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The two avatar shapes actually found in Figma, not a simple size scale: [header] (44px, light-blue background, thin yellow border, soft shadow) and [profile] (128px, light-sky background, darker navy border, hard 3D shadow at 4px/4px/0px with no blur).
enum QaaAvatarVariant { header, profile }

/// Unified avatar matching the "SpongeBob Avatar" component confirmed across every designed screen (Home, Complaint Details, Profile, etc. — PLAN.md section 3); the two [QaaAvatarVariant] shapes are extracted from the real Figma review (24 Aug 2026), not invented.
///
/// Precedence for what's shown: [assetPath] (a bundled character portrait actually extracted from
/// Figma — see [characterAvatarAsset]) wins first; then [imageUrl] (a real uploaded/remote photo,
/// once the backend serves one); otherwise the user's first initial as a fallback. Only characters
/// with real Figma-sourced art get an [assetPath] — everyone else intentionally keeps the initial
/// fallback rather than inventing a portrait for them (Figma Assets Extraction pass, 2026-08-25).
class QaaAvatar extends StatelessWidget {
  const QaaAvatar({
    super.key,
    this.assetPath,
    this.imageUrl,
    this.displayName,
    this.variant = QaaAvatarVariant.header,
    double? size,
  }) : _explicitSize = size;

  /// A bundled asset (e.g. `assets/images/characters/spongebob_avatar.jpg`) — takes precedence over
  /// [imageUrl] when both are set.
  final String? assetPath;
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
              // Hard shadow, no blur — matches the CTA button style
              color: Color(0x33002431),
              offset: Offset(4, 4),
            ),
          ],
      };

  @override
  Widget build(BuildContext context) {
    final hasAsset = assetPath != null && assetPath!.isNotEmpty;
    final hasImageUrl = imageUrl != null && imageUrl!.isNotEmpty;

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
        child: hasAsset
            ? Image.asset(
                assetPath!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _fallback(),
              )
            : hasImageUrl
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
