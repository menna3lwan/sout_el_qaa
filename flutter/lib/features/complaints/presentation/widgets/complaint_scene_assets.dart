/// Maps a complaint id to the bundled Figma-sourced scene photo for it, if one exists.
///
/// Figma Assets Extraction pass (2026-08-25): the Figma file only actually illustrates one specific
/// complaint scene (the cracked street on شارع الأناناس) plus two more generic scene photos (a shop
/// exterior, a broken streetlight at night) that fit two of the other seeded complaints by subject.
/// Every other seeded complaint (water leak, broken sidewalk, overflowing bins, etc.) has no matching
/// art in Figma — [complaintThumbnailAsset] and [complaintHeroAsset] deliberately return null for
/// those rather than reusing an unrelated photo, so callers keep their existing no-image layout for
/// them. Extend these maps only when a real matching asset is extracted from Figma — never by
/// generating new scene art.
const Map<String, String> _thumbnailAssets = {
  // c1 — "الشارع الرئيسي مكسر" (the cracked street on شارع الأناناس).
  'c1': 'assets/images/complaints/complaint_road_crack_banner.jpg',
  // c3 — "أعمدة الإنارة لا تعمل" (broken streetlights).
  'c3': 'assets/images/complaints/complaint_streetlight_night.jpg',
  // c9 — "الزبالة قدام محلي بتبعد الزباين" (garbage outside a shopfront).
  'c9': 'assets/images/complaints/complaint_shop_exterior.jpg',
};

const Map<String, String> _heroAssets = {
  // c1 only — the one complaint Figma actually drew a Complaint Details hero photo for
  // (SpongeBob and Patrick standing at the crater).
  'c1': 'assets/images/complaints/complaint_road_crack_hero.png',
};

/// The small thumbnail shown on a complaint's list card (Home's trending/recent lists, Complaints
/// List, My Complaints), or null if this complaint has no matching Figma art.
String? complaintThumbnailAsset(String complaintId) =>
    _thumbnailAssets[complaintId];

/// The large hero photo shown on Complaint Details, or null if this complaint has no matching Figma
/// art (in which case the page falls back to `complaint.mediaUrls`, if any were uploaded).
String? complaintHeroAsset(String complaintId) => _heroAssets[complaintId];
