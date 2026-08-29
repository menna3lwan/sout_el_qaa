import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../domain/entities/profile_stats.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileLoaded extends ProfileState {
  const ProfileLoaded({required this.user, required this.stats});

  final User user;
  final ProfileStats stats;

  @override
  List<Object?> get props => [user, stats];
}

final class ProfileError extends ProfileState {
  const ProfileError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
