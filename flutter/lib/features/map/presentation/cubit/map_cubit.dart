import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../complaints/domain/repositories/complaint_repository.dart';
import 'map_state.dart';

final class MapCubit extends Cubit<MapPinsState> {
  MapCubit(this._repository) : super(const MapPinsLoading());

  final ComplaintRepository _repository;

  Future<void> load() async {
    emit(const MapPinsLoading());
    final result = await _repository.getMapPins();
    result.fold(
      (failure) => emit(MapPinsError(failure.message)),
      (pins) => emit(MapPinsLoaded(pins)),
    );
  }
}
