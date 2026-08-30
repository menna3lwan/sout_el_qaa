import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sout_el_qaa/core/storage/secure_storage_service.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/complaint.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/complaint_status.dart';
import 'package:sout_el_qaa/features/complaints/domain/repositories/complaint_repository.dart';
import 'package:sout_el_qaa/features/create_complaint/presentation/cubit/create_complaint_cubit.dart';
import 'package:sout_el_qaa/features/create_complaint/presentation/cubit/create_complaint_state.dart';

class MockComplaintRepository extends Mock implements ComplaintRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockComplaintRepository repository;
  late MockSecureStorageService secureStorage;

  final createdComplaint = Complaint(
    id: 'c1',
    title: 'حفرة في الشارع',
    description: 'حفرة كبيرة محتاجة صيانة فورية',
    categoryId: 'roads',
    severity: ComplaintSeverity.high,
    status: ComplaintStatus.received,
    location: 'شارع الأناناس',
    lat: 30.0,
    lng: 31.0,
    views: 0,
    likes: 0,
    mediaUrls: const [],
    authorId: 'u1',
    createdAt: DateTime(2026),
  );

  /// A state that already passes every [CreateComplaintCubit._validateAll] check, so [submit]
  /// tests exercise the submission path itself rather than re-testing validation.
  const validState = CreateComplaintState(
    title: 'حفرة في الشارع',
    description: 'حفرة كبيرة محتاجة صيانة فورية',
    categoryId: 'roads',
    location: 'شارع الأناناس',
    lat: 30.0,
    lng: 31.0,
    severity: ComplaintSeverity.high,
  );

  CreateComplaintCubit buildCubit() =>
      CreateComplaintCubit(repository, secureStorage);

  setUpAll(() {
    registerFallbackValue(ComplaintSeverity.low);
  });

  setUp(() {
    repository = MockComplaintRepository();
    secureStorage = MockSecureStorageService();
  });

  group('nextStep', () {
    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'emits validationError and stays on the form step when required fields are missing',
      build: buildCubit,
      act: (cubit) => cubit.nextStep(),
      expect: () => [
        isA<CreateComplaintState>()
            .having(
              (s) => s.status,
              'status',
              CreateComplaintStatus.validationError,
            )
            .having((s) => s.step, 'step', CreateComplaintStep.form)
            .having(
              (s) => s.fieldErrors.keys,
              'fieldErrors.keys',
              containsAll(['title', 'category', 'location', 'severity']),
            ),
      ],
    );

    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'advances to the review step once every field is valid',
      build: buildCubit,
      seed: () => validState,
      act: (cubit) => cubit.nextStep(),
      expect: () => [
        isA<CreateComplaintState>()
            .having((s) => s.step, 'step', CreateComplaintStep.review)
            .having((s) => s.status, 'status', CreateComplaintStatus.editing)
            .having((s) => s.fieldErrors, 'fieldErrors', isEmpty),
      ],
    );

    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'does nothing when already on the review step',
      build: buildCubit,
      seed: () => validState.copyWith(step: CreateComplaintStep.review),
      act: (cubit) => cubit.nextStep(),
      expect: () => <CreateComplaintState>[],
    );
  });

  group('previousStep', () {
    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'goes back to the form step from review',
      build: buildCubit,
      seed: () => validState.copyWith(step: CreateComplaintStep.review),
      act: (cubit) => cubit.previousStep(),
      expect: () => [
        isA<CreateComplaintState>()
            .having((s) => s.step, 'step', CreateComplaintStep.form),
      ],
    );
  });

  group('submit', () {
    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'emits failure without calling the repository when the draft is invalid',
      build: buildCubit,
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<CreateComplaintState>().having(
          (s) => s.status,
          'status',
          CreateComplaintStatus.validationError,
        ),
      ],
      verify: (_) {
        verifyNever(() => secureStorage.readUserId());
      },
    );

    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'emits failure when there is no signed-in user id, without calling createComplaint',
      build: () {
        when(() => secureStorage.readUserId()).thenAnswer((_) async => null);
        return buildCubit();
      },
      seed: () => validState,
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<CreateComplaintState>().having(
          (s) => s.status,
          'status',
          CreateComplaintStatus.submitting,
        ),
        isA<CreateComplaintState>()
            .having((s) => s.status, 'status', CreateComplaintStatus.failure)
            .having(
              (s) => s.failureMessageKey,
              'failureMessageKey',
              'unauthorizedMessage',
            ),
      ],
      verify: (_) {
        verifyNever(
          () => repository.createComplaint(
            title: any(named: 'title'),
            description: any(named: 'description'),
            categoryId: any(named: 'categoryId'),
            severity: any(named: 'severity'),
            location: any(named: 'location'),
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
            mediaUrls: any(named: 'mediaUrls'),
            authorId: any(named: 'authorId'),
          ),
        );
      },
    );

    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'emits submitting then success with the created complaint',
      build: () {
        when(() => secureStorage.readUserId()).thenAnswer((_) async => 'u1');
        when(
          () => repository.createComplaint(
            title: any(named: 'title'),
            description: any(named: 'description'),
            categoryId: any(named: 'categoryId'),
            severity: any(named: 'severity'),
            location: any(named: 'location'),
            lat: any(named: 'lat'),
            lng: any(named: 'lng'),
            mediaUrls: any(named: 'mediaUrls'),
            authorId: any(named: 'authorId'),
          ),
        ).thenAnswer((_) async => Right(createdComplaint));
        return buildCubit();
      },
      seed: () => validState,
      act: (cubit) => cubit.submit(),
      expect: () => [
        isA<CreateComplaintState>().having(
          (s) => s.status,
          'status',
          CreateComplaintStatus.submitting,
        ),
        isA<CreateComplaintState>()
            .having((s) => s.status, 'status', CreateComplaintStatus.success)
            .having(
              (s) => s.createdComplaint,
              'createdComplaint',
              createdComplaint,
            ),
      ],
    );
  });

  group('attachPhoto / removePhoto', () {
    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'appends the uploaded url to mediaUrls on success',
      build: () {
        when(() => repository.uploadMedia(any())).thenAnswer(
          (_) async => const Right('https://cdn.example/photo.jpg'),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.attachPhoto('/tmp/photo.jpg'),
      expect: () => [
        isA<CreateComplaintState>().having(
          (s) => s.isUploadingMedia,
          'isUploadingMedia',
          true,
        ),
        isA<CreateComplaintState>()
            .having((s) => s.isUploadingMedia, 'isUploadingMedia', false)
            .having(
          (s) => s.mediaUrls,
          'mediaUrls',
          ['https://cdn.example/photo.jpg'],
        ),
      ],
    );

    blocTest<CreateComplaintCubit, CreateComplaintState>(
      'removes only the matching url',
      build: buildCubit,
      seed: () => const CreateComplaintState(
        mediaUrls: ['a.jpg', 'b.jpg'],
      ),
      act: (cubit) => cubit.removePhoto('a.jpg'),
      expect: () => [
        isA<CreateComplaintState>()
            .having((s) => s.mediaUrls, 'mediaUrls', ['b.jpg']),
      ],
    );
  });
}
