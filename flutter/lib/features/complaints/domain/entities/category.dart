import 'package:equatable/equatable.dart';

/// A complaint category (مياه/طرق/نظافة/كهرباء — [ComplaintConstants.confirmedCategorySlugs]);
/// [name] is business content from the mock server, not translatable UI chrome, so it's shown
/// as-is regardless of locale.
base class Category extends Equatable {
  const Category({required this.id, required this.name, required this.iconKey});

  final String id;
  final String name;
  final String iconKey;

  @override
  List<Object?> get props => [id, name, iconKey];
}
