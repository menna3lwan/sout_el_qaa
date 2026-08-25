import 'package:equatable/equatable.dart';

/// A complaint category (مياه/طرق/نظافة/كهرباء — [ComplaintConstants.confirmedCategorySlugs]); [name] is real Qaa-El-Hamour business content from the mock server, not translatable UI chrome, so it's shown as-is regardless of locale (same rule already applied to complaint titles/descriptions).
base class Category extends Equatable {
  const Category({required this.id, required this.name, required this.iconKey});

  final String id;
  final String name;
  final String iconKey;

  @override
  List<Object?> get props => [id, name, iconKey];
}
