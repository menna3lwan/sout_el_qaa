/// Fixed values/keys from the "قاع الهامور" domain, confirmed from the real Figma review (PLAN.md section 15) — not translatable display text (that's ARB/l10n's job), these are fixed identifiers for the complaint domain specifically.
///
/// Moved here from core/constants/ (was AppStrings) and renamed ComplaintConstants because it knows complaint-domain details (categories, statuses, severities), not app-wide generic identifiers — same rule as StatusBadge (see presentation/widgets/status_badge.dart); still used by other features (Home, Create Complaint) since they work with the same entity, which doesn't mean it belongs back in core.
abstract final class ComplaintConstants {
  /// The 4 confirmed complaint categories from the Home screen text — [A4] open to expansion later (not a closed enum, or backend-driven).
  static const List<String> confirmedCategorySlugs = [
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
