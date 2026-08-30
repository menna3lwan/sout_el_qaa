import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sout_el_qaa/core/errors/failures.dart';
import 'package:sout_el_qaa/features/auth/domain/entities/user.dart';
import 'package:sout_el_qaa/features/auth/domain/repositories/auth_repository.dart';
import 'package:sout_el_qaa/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sout_el_qaa/features/auth/presentation/cubit/auth_state.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  const user = User(
    id: 'u1',
    username: 'shafiq',
    email: 'shafiq@qaa-el-hamour.eg',
    displayName: 'شفيق',
  );

  setUp(() {
    repository = MockAuthRepository();
  });

  group('AuthCubit.login', () {
    blocTest<AuthCubit, AuthState>(
      'emits validationError and never calls the repository when the email is malformed',
      build: () => AuthCubit(repository),
      act: (cubit) =>
          cubit.login(email: 'not-an-email', password: 'qaaHamour1'),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.validationError)
            .having(
              (s) => s.fieldErrors['email'],
              'fieldErrors[email]',
              'validationInvalidEmail',
            ),
      ],
      verify: (_) {
        verifyNever(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits submitting then success with the signed-in user on valid credentials',
      build: () {
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(user));
        return AuthCubit(repository);
      },
      act: (cubit) =>
          cubit.login(email: 'shafiq@qaa-el-hamour.eg', password: 'qaaHamour1'),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.submitting),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', user),
      ],
    );

    blocTest<AuthCubit, AuthState>(
      'emits submitting then failure with the mapped message on wrong credentials',
      build: () {
        when(
          () => repository.login(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer(
          (_) async =>
              const Left(UnauthorizedFailure(message: 'unauthorizedMessage')),
        );
        return AuthCubit(repository);
      },
      act: (cubit) =>
          cubit.login(email: 'shafiq@qaa-el-hamour.eg', password: 'wrongpass1'),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.submitting),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.failure)
            .having(
              (s) => s.failureMessageKey,
              'failureMessageKey',
              'unauthorizedMessage',
            ),
      ],
    );
  });

  group('AuthCubit.register', () {
    blocTest<AuthCubit, AuthState>(
      'emits validationError with a mismatch key when passwords differ',
      build: () => AuthCubit(repository),
      act: (cubit) => cubit.register(
        username: 'shafiq',
        email: 'shafiq@qaa-el-hamour.eg',
        password: 'qaaHamour1',
        confirmPassword: 'different1',
      ),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.validationError)
            .having(
              (s) => s.fieldErrors['confirmPassword'],
              'fieldErrors[confirmPassword]',
              'validationPasswordMismatch',
            ),
      ],
      verify: (_) {
        verifyNever(
          () => repository.register(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        );
      },
    );

    blocTest<AuthCubit, AuthState>(
      'emits submitting then success on a valid registration',
      build: () {
        when(
          () => repository.register(
            username: any(named: 'username'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async => const Right(user));
        return AuthCubit(repository);
      },
      act: (cubit) => cubit.register(
        username: 'shafiq',
        email: 'shafiq@qaa-el-hamour.eg',
        password: 'qaaHamour1',
        confirmPassword: 'qaaHamour1',
      ),
      expect: () => [
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.submitting),
        isA<AuthState>()
            .having((s) => s.status, 'status', AuthStatus.success)
            .having((s) => s.user, 'user', user),
      ],
    );
  });
}
