import '../../domain/entities/complaint.dart';
import 'complaint_model.dart' show statusFromSlug;

final class ComplaintMapPinModel extends ComplaintMapPin {
  const ComplaintMapPinModel({
    required super.id,
    required super.lat,
    required super.lng,
    required super.categoryId,
    required super.status,
  });

  factory ComplaintMapPinModel.fromJson(Map<String, dynamic> json) =>
      ComplaintMapPinModel(
        id: json['id'] as String,
        lat: (json['lat'] as num).toDouble(),
        lng: (json['lng'] as num).toDouble(),
        categoryId: json['categoryId'] as String,
        status: statusFromSlug(json['status'] as String),
      );
}
