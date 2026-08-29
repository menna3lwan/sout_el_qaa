/// Maps a resident's display name to their bundled Figma-sourced avatar asset, for use as
/// [QaaAvatar]'s `assetPath`.
///
/// Figma Assets Extraction pass (2026-08-25): the Figma file only actually contains portrait art for
/// two residents — SpongeBob (the app's "current user" avatar, reused across every screen) and
/// Squidward (a commenter avatar on Complaint Details). The other residents seeded in the mock data
/// (Patrick, Sandy, Mr. Krabs, Plankton) have no corresponding art in Figma; rather than inventing
/// portraits for them, [characterAvatarAsset] deliberately returns null for anyone not in this map,
/// so [QaaAvatar] falls through to its existing initial-letter fallback for them. Extend this map
/// only when a real asset for that character is extracted from Figma (or supplied by the user) —
/// never by drawing/generating new character art.
const Map<String, String> _characterAvatarAssets = {
  'سبونج بوب سكوير بانتس': 'assets/images/characters/spongebob_avatar.jpg',
  'سكويدوارد تنتاكلز': 'assets/images/characters/squidward_avatar.jpg',
};

/// Looks up the bundled avatar asset for [displayName], or null if this resident has no real
/// Figma-sourced portrait (see [_characterAvatarAssets] doc comment).
String? characterAvatarAsset(String? displayName) {
  if (displayName == null) return null;
  return _characterAvatarAssets[displayName];
}
