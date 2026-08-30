import 'package:equatable/equatable.dart';

import '../../../complaints/domain/entities/complaint.dart';

sealed class MapPinsState extends Equatable {
  const MapPinsState();

  @override
  List<Object?> get props => [];
}

final class MapPinsLoading extends MapPinsState {
  const MapPinsLoading();
}

final class MapPinsLoaded extends MapPinsState {
  const MapPinsLoaded(this.pins);

  final List<ComplaintMapPin> pins;

  @override
  List<Object?> get props => [pins];
}

final class MapPinsError extends MapPinsState {
  const MapPinsError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
