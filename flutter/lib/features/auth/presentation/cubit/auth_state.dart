import 'package:equatable/equatable.dart';

import '../../domain/entities/user.dart';

/// Form-lifecycle states shared by Login and Register (both are simple credential forms) — [validationError] carries per-field ARB-key errors so the UI shows them inline (PLAN.md section 7), never as a generic snackbar.
enum AuthStatus { initial, validationError, submitting, success, failure }

final class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.initial,
    this.fieldErrors = const {},
    this.failureMessageKey,
    this.user,
  });

  final AuthStatus status;
  final Map<String, String> fieldErrors;
  final String? failureMessageKey;
  final User? user;

  AuthState copyWith({
    AuthStatus? status,
    Map<String, String>? fieldErrors,
    String? failureMessageKey,
    User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      fieldErrors: fieldErrors ?? const {},
      failureMessageKey: failureMessageKey,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [status, fieldErrors, failureMessageKey, user];
}
