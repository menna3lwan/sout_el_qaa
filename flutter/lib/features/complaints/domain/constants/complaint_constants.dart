/// Fixed identifiers for the complaint domain (categories, statuses, severities) — not
/// translatable display text (that's ARB/l10n's job). Lives here rather than core/constants/
/// because it's complaint-domain knowledge, not an app-wide generic identifier, even though other
/// features (Home, Create Complaint) also use it against the same entity.
abstract final class ComplaintConstants {
  /// Open to expansion later — not a closed enum or backend-driven list.
  static const List<String> confirmedCategorySlugs = [
    'other',
    'water',
    'roads',
    'cleanliness',
    'electricity',
  ];

  /// Confirmed complaint lifecycle (3 stages) from Complaint Details and Complaints List.
  static const List<String> complaintStatusSlugs = [
    'received',
    'inReview', // Figma uses two different Arabic phrasings for this status: "قيد المراجعة" and "قيد المعالجة"
    'resolved',
  ];

  /// Severity levels confirmed from the complaint submission form.
  static const List<String> severitySlugs = [
    'high',
    'medium',
    'low',
  ];
}
