import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/storage/secure_storage_service.dart';
import '../../domain/entities/complaint_status.dart';
import '../../domain/repositories/complaint_repository.dart';
import 'complaints_state.dart';

/// Drives the Complaints List screen (all 3 filter tabs); re-fetches from the server on every filter
/// change rather than filtering a locally-cached full list, since the server already supports
/// authorId/status query filtering (PLAN.md section 5: Repository/DataSource own filtering, not Presentation).
final class ComplaintsCubit extends Cubit<ComplaintsState> {
  ComplaintsCubit(this._repository, this._secureStorage)
      : super(const ComplaintsLoading());

  final ComplaintRepository _repository;
  final SecureStorageService _secureStorage;

  Future<void> load({ComplaintsFilter filter = ComplaintsFilter.all}) async {
    emit(const ComplaintsLoading());

    final String? authorId;
    if (filter == ComplaintsFilter.mine) {
      authorId = await _secureStorage.readUserId();
    } else {
      authorId = null;
    }

    final result = await _repository.getComplaints(
      authorId: authorId,
      status:
          filter == ComplaintsFilter.resolved ? ComplaintStatus.resolved : null,
    );

    result.fold(
      (failure) => emit(ComplaintsError(failure.message)),
      (complaints) =>
          emit(ComplaintsLoaded(complaints: complaints, filter: filter)),
    );
  }
}
