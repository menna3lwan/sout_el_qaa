import 'package:equatable/equatable.dart';

import '../../../auth/domain/entities/user.dart';
import '../../../complaints/domain/entities/category.dart';
import '../../../complaints/domain/entities/complaint.dart';

sealed class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

final class HomeLoading extends HomeState {
  const HomeLoading();
}

final class HomeLoaded extends HomeState {
  const HomeLoaded({
    required this.user,
    required this.categories,
    required this.trending,
    required this.recentActivity,
  });

  final User user;
  final List<Category> categories;
  final List<Complaint> trending;
  final List<Complaint> recentActivity;

  @override
  List<Object?> get props => [user, categories, trending, recentActivity];
}

final class HomeError extends HomeState {
  const HomeError(this.messageKey);

  final String messageKey;

  @override
  List<Object?> get props => [messageKey];
}
