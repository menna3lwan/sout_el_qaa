import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/utils/validators.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Drives both LoginPage and RegisterPage; validation happens here (not in the widget), matching PLAN.md section 1.2 — "no business logic inside widgets".
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repository) : super(const AuthState());

  final AuthRepository _repository;

  Future<void> login({required String email, required String password}) async {
    final fieldErrors = <String, String>{};
    final emailError = Validators.email(email);
    final passwordError = Validators.required(password);
    if (emailError != null) fieldErrors['email'] = emailError;
    if (passwordError != null) fieldErrors['password'] = passwordError;

    if (fieldErrors.isNotEmpty) {
      emit(state.copyWith(
          status: AuthStatus.validationError, fieldErrors: fieldErrors));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, fieldErrors: const {}));
    final result = await _repository.login(email: email, password: password);
    result.fold(
      (failure) => emit(
        state.copyWith(
            status: AuthStatus.failure, failureMessageKey: failure.message),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }

  Future<void> register({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    final fieldErrors = <String, String>{};
    final usernameError = Validators.required(username);
    final emailError = Validators.email(email);
    final passwordError = Validators.password(password);
    final confirmError = Validators.confirmPassword(confirmPassword, password);
    if (usernameError != null) fieldErrors['username'] = usernameError;
    if (emailError != null) fieldErrors['email'] = emailError;
    if (passwordError != null) fieldErrors['password'] = passwordError;
    if (confirmError != null) fieldErrors['confirmPassword'] = confirmError;

    if (fieldErrors.isNotEmpty) {
      emit(state.copyWith(
          status: AuthStatus.validationError, fieldErrors: fieldErrors));
      return;
    }

    emit(state.copyWith(status: AuthStatus.submitting, fieldErrors: const {}));
    final result = await _repository.register(
      username: username,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
            status: AuthStatus.failure, failureMessageKey: failure.message),
      ),
      (user) => emit(state.copyWith(status: AuthStatus.success, user: user)),
    );
  }
}
