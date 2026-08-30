import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sout_el_qaa/core/errors/failures.dart';
import 'package:sout_el_qaa/core/storage/secure_storage_service.dart';
import 'package:sout_el_qaa/features/auth/domain/entities/user.dart';
import 'package:sout_el_qaa/features/auth/domain/repositories/auth_repository.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/category.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/comment.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/complaint.dart';
import 'package:sout_el_qaa/features/complaints/domain/entities/complaint_status.dart';
import 'package:sout_el_qaa/features/complaints/domain/repositories/complaint_repository.dart';
import 'package:sout_el_qaa/features/complaints/presentation/cubit/complaint_details_cubit.dart';
import 'package:sout_el_qaa/features/complaints/presentation/cubit/complaint_details_state.dart';

class MockComplaintRepository extends Mock implements ComplaintRepository {}

class MockAuthRepository extends Mock implements AuthRepository {}

class MockSecureStorageService extends Mock implements SecureStorageService {}

void main() {
  late MockComplaintRepository repository;
  late MockAuthRepository authRepository;
  late MockSecureStorageService secureStorage;

  final complaint = Complaint(
    id: 'c1',
    title: 'حفرة في الشارع',
    description: 'حفرة كبيرة محتاجة صيانة',
    categoryId: 'roads',
    severity: ComplaintSeverity.high,
    status: ComplaintStatus.received,
    location: 'شارع الأناناس',
    lat: 30.0,
    lng: 31.0,
    views: 10,
    likes: 5,
    mediaUrls: const [],
    authorId: 'u1',
    createdAt: DateTime(2026),
  );

  const category = Category(id: 'roads', name: 'طرق', iconKey: 'roads');

  ComplaintDetailsCubit buildCubit() =>
      ComplaintDetailsCubit(repository, authRepository, secureStorage);

  setUp(() {
    repository = MockComplaintRepository();
    authRepository = MockAuthRepository();
    secureStorage = MockSecureStorageService();
  });

  group('load', () {
    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'emits loading then loaded with the resolved category on success',
      build: () {
        when(() => repository.getComplaintById('c1'))
            .thenAnswer((_) async => Right(complaint));
        when(() => repository.getComments('c1'))
            .thenAnswer((_) async => const Right(<Comment>[]));
        when(() => repository.getCategories())
            .thenAnswer((_) async => const Right([category]));
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        const ComplaintDetailsLoading(),
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.complaint, 'complaint', complaint)
            .having((s) => s.category, 'category', category)
            .having((s) => s.isLiked, 'isLiked', false),
      ],
    );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'emits loading then error when the complaint fetch fails, without fetching comments',
      build: () {
        when(() => repository.getComplaintById('missing')).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'genericErrorMessage')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load('missing'),
      expect: () => [
        const ComplaintDetailsLoading(),
        const ComplaintDetailsError('genericErrorMessage'),
      ],
      verify: (_) {
        verifyNever(() => repository.getComments(any()));
      },
    );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'falls back to a null category when the categories fetch fails, without failing the page',
      build: () {
        when(() => repository.getComplaintById('c1'))
            .thenAnswer((_) async => Right(complaint));
        when(() => repository.getComments('c1'))
            .thenAnswer((_) async => const Right(<Comment>[]));
        when(() => repository.getCategories()).thenAnswer(
          (_) async =>
              const Left(ServerFailure(message: 'genericErrorMessage')),
        );
        return buildCubit();
      },
      act: (cubit) => cubit.load('c1'),
      expect: () => [
        const ComplaintDetailsLoading(),
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.category, 'category', isNull),
      ],
    );
  });

  group('toggleLike', () {
    ComplaintDetailsLoaded loadedState({bool isDisliked = false}) =>
        ComplaintDetailsLoaded(
          complaint: complaint,
          comments: const [],
          isLiked: false,
          isDisliked: isDisliked,
        );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'turns the like on and updates the count from the repository',
      build: () {
        when(() => repository.like('c1'))
            .thenAnswer((_) async => const Right(6));
        return buildCubit();
      },
      seed: loadedState,
      act: (cubit) => cubit.toggleLike(),
      expect: () => [
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.isLiked, 'isLiked', true)
            .having((s) => s.complaint.likes, 'complaint.likes', 6),
      ],
      verify: (_) {
        verifyNever(() => repository.undislike(any()));
      },
    );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'clears an active dislike first when turning like on (mutual exclusivity)',
      build: () {
        when(() => repository.undislike('c1'))
            .thenAnswer((_) async => const Right(0));
        when(() => repository.like('c1'))
            .thenAnswer((_) async => const Right(6));
        return buildCubit();
      },
      seed: () => loadedState(isDisliked: true),
      act: (cubit) => cubit.toggleLike(),
      expect: () => [
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.isLiked, 'isLiked', true)
            .having((s) => s.isDisliked, 'isDisliked', false),
      ],
      verify: (_) {
        verify(() => repository.undislike('c1')).called(1);
      },
    );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'leaves state unchanged when the repository call fails',
      build: () {
        when(() => repository.like('c1')).thenAnswer(
          (_) async => const Left(
            NetworkFailure(message: 'noInternetConnectionMessage'),
          ),
        );
        return buildCubit();
      },
      seed: loadedState,
      act: (cubit) => cubit.toggleLike(),
      expect: () => <ComplaintDetailsState>[],
    );
  });

  group('postComment', () {
    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'appends the new comment using the current user\'s display name',
      build: () {
        const author = User(
          id: 'u1',
          username: 'shafiq',
          email: 'shafiq@qaa-el-hamour.eg',
          displayName: 'شفيق',
        );
        when(() => authRepository.currentUser())
            .thenAnswer((_) async => const Right(author));
        when(
          () => repository.addComment(
            complaintId: 'c1',
            text: 'تمام يا جار',
            authorName: 'شفيق',
          ),
        ).thenAnswer(
          (_) async => Right(
            Comment(
              id: 'cm1',
              complaintId: 'c1',
              authorId: 'u1',
              authorName: 'شفيق',
              text: 'تمام يا جار',
              createdAt: DateTime(2026),
            ),
          ),
        );
        return buildCubit();
      },
      seed: () => ComplaintDetailsLoaded(
        complaint: complaint,
        comments: const [],
        isLiked: false,
      ),
      act: (cubit) => cubit.postComment('تمام يا جار'),
      expect: () => [
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.isPostingComment, 'isPostingComment', true),
        isA<ComplaintDetailsLoaded>()
            .having((s) => s.isPostingComment, 'isPostingComment', false)
            .having((s) => s.comments.length, 'comments.length', 1),
      ],
    );

    blocTest<ComplaintDetailsCubit, ComplaintDetailsState>(
      'does nothing for a blank comment',
      build: buildCubit,
      seed: () => ComplaintDetailsLoaded(
        complaint: complaint,
        comments: const [],
        isLiked: false,
      ),
      act: (cubit) => cubit.postComment('   '),
      expect: () => <ComplaintDetailsState>[],
      verify: (_) {
        verifyNever(() => authRepository.currentUser());
      },
    );
  });
}
