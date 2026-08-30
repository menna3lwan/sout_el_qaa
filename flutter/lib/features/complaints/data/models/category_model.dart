import '../../domain/entities/category.dart';

final class CategoryModel extends Category {
  const CategoryModel({
    required super.id,
    required super.name,
    required super.iconKey,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: json['id'] as String,
        name: json['name'] as String,
        iconKey: json['iconKey'] as String,
      );
}
