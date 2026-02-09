import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/entities/absence.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/repositories/absence_repository.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/usecases/get_absences_usecase.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/domain/usecases/get_members_usecase.dart';
import 'package:crewmeister_frontend_coding_challenge/features/absences/presentation/bloc/absences_bloc.dart';

import '../../../../test_constants.dart';
import 'absences_bloc_test.mocks.dart';

@GenerateMocks([GetAbsencesUseCase, GetMembersUseCase, AbsenceRepository])
void main() {
  late MockGetAbsencesUseCase mockGetAbsencesUseCase;
  late MockGetMembersUseCase mockGetMembersUseCase;
  late MockAbsenceRepository mockRepository;

  final testMembers = TestConstants.tMemberList;
  final testAbsences = TestConstants.tAbsenceModels;


  setUp(() {
    mockGetAbsencesUseCase = MockGetAbsencesUseCase();
    mockGetMembersUseCase = MockGetMembersUseCase();
    mockRepository = MockAbsenceRepository();

    // Setup default repository access
    when(mockGetAbsencesUseCase.repository).thenReturn(mockRepository);
  });

  group('AbsencesBloc', () {
    test('initial state is AbsencesInitial', () {
      final bloc = AbsencesBloc(
        getAbsencesUseCase: mockGetAbsencesUseCase,
        getMembersUseCase: mockGetMembersUseCase,
      );
      expect(bloc.state, equals(AbsencesInitial()));
      bloc.close();
    });

    group('LoadAbsencesEvent', () {
      test(
        'emits [AbsencesLoading, AbsencesLoaded] when load is successful',
        () async {
          when(
            mockRepository.getMembers(),
          ).thenAnswer((_) async => testMembers);
          when(
            mockGetAbsencesUseCase.execute(
              page: anyNamed('page'),
              pageSize: anyNamed('pageSize'),
              types: anyNamed('types'),
              statuses: anyNamed('statuses'),
              startDate: anyNamed('startDate'),
              endDate: anyNamed('endDate'),
            ),
          ).thenAnswer((_) async => AbsencesResultModel(testAbsences, 2));

          final bloc = AbsencesBloc(
            getAbsencesUseCase: mockGetAbsencesUseCase,
            getMembersUseCase: mockGetMembersUseCase,
          );

          final states = <AbsencesState>[];
          final subscription = bloc.stream.listen(states.add);

          bloc.add(const LoadAbsencesEvent());
          await Future.delayed(const Duration(milliseconds: 2000));

          expectLater(
            states,
            containsAllInOrder([
              isA<AbsencesLoading>(),
              isA<AbsencesLoaded>()
                  .having((s) => s.absences.length, 'absences length', 2)
                  .having((s) => s.totalCount, 'totalCount', 2)
                  .having((s) => s.members.length, 'members length', 2),
            ]),
          );

          verify(mockRepository.getMembers()).called(1);
          verify(
            mockGetAbsencesUseCase.execute(
              page: 1,
              pageSize: 10,
              types: null,
              statuses: null,
              startDate: null,
              endDate: null,
            ),
          ).called(1);

          await subscription.cancel();
          await bloc.close();
        },
      );

      test('emits [AbsencesLoading, AbsencesError] when load fails', () async {
        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenThrow(Exception('Failed to load absences'));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        final states = <AbsencesState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const LoadAbsencesEvent());
        await Future.delayed(const Duration(milliseconds: 2000));

        expectLater(
          states,
          containsAllInOrder([
            isA<AbsencesLoading>(),
            isA<AbsencesError>().having(
              (s) => s.message,
              'error message',
              contains('Failed to load absences'),
            ),
          ]),
        );

        await subscription.cancel();
        await bloc.close();
      });
    });

    group('LoadNextPageEvent', () {
      test('loads next page and appends absences to existing list', () async {
        final moreAbsences = [
          Absence(
            id: 3,
            userId: 100,
            crewId: 1,
            type: 'vacation',
            startDate: DateTime(2024, 3, 1),
            endDate: DateTime(2024, 3, 5),
            memberNote: 'Spring break',
            createdAt: DateTime(2024, 2, 1),
          ),
        ];

        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(testAbsences, 3));

        when(
          mockGetAbsencesUseCase.execute(
            page: 2,
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(moreAbsences, 3));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        final states = <AbsencesState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const LoadAbsencesEvent());
        await Future.delayed(const Duration(milliseconds: 2000));
        bloc.add(LoadNextPageEvent());
        await Future.delayed(const Duration(milliseconds: 500));

        expectLater(
          states.where((s) => s is AbsencesLoaded).toList(),
          containsAllInOrder([
            isA<AbsencesLoaded>()
                .having((s) => s.absences.length, 'initial absences', 2)
                .having((s) => s.isLoadingMore, 'isLoadingMore', false),
            isA<AbsencesLoaded>().having(
              (s) => s.isLoadingMore,
              'isLoadingMore',
              true,
            ),
            isA<AbsencesLoaded>()
                .having((s) => s.absences.length, 'absences after load', 3)
                .having((s) => s.isLoadingMore, 'isLoadingMore', false),
          ]),
        );

        await subscription.cancel();
        await bloc.close();
      });

      test('does not load next page when all data is already loaded', () async {
        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(testAbsences, 2));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        bloc.add(const LoadAbsencesEvent());
        await Future.delayed(const Duration(milliseconds: 2000));

        final statesBefore = bloc.stream.toList();
        bloc.add(LoadNextPageEvent());
        await Future.delayed(const Duration(milliseconds: 500));

        // Should only call execute once (for initial load, not for next page)
        verify(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).called(1);

        await bloc.close();
      });
    });

    group('ApplyFiltersEvent', () {
      test('applies filters and reloads absences', () async {
        final filteredAbsences = [testAbsences.first];

        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
            types: ['vacation'],
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(filteredAbsences, 1));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        final states = <AbsencesState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const ApplyFiltersEvent(types: ['vacation']));
        await Future.delayed(const Duration(milliseconds: 2000));

        expectLater(
          states,
          containsAllInOrder([
            isA<AbsencesLoading>(),
            isA<AbsencesLoaded>()
                .having((s) => s.absences.length, 'absences length', 1)
                .having((s) => s.filterTypes, 'filterTypes', ['vacation']),
          ]),
        );

        verify(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 10,
            types: ['vacation'],
            statuses: null,
            startDate: null,
            endDate: null,
          ),
        ).called(1);

        await subscription.cancel();
        await bloc.close();
      });

      test('applies date range filters correctly', () async {
        final startDate = DateTime(2024, 1, 1);
        final endDate = DateTime(2024, 1, 31);

        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: anyNamed('page'),
            pageSize: anyNamed('pageSize'),
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: startDate,
            endDate: endDate,
          ),
        ).thenAnswer((_) async => AbsencesResultModel([testAbsences.first], 1));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        bloc.add(ApplyFiltersEvent(startDate: startDate, endDate: endDate));
        await Future.delayed(const Duration(milliseconds: 2000));

        verify(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 10,
            types: null,
            statuses: null,
            startDate: startDate,
            endDate: endDate,
          ),
        ).called(1);

        await bloc.close();
      });
    });

    group('PreviewFilterCountEvent', () {
      test('updates filter preview count when in loaded state', () async {
        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 10,
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(testAbsences, 2));

        when(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 1,
            types: ['vacation'],
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel([], 5));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        final states = <AbsencesState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const LoadAbsencesEvent());
        await Future.delayed(const Duration(milliseconds: 2000));
        bloc.add(const PreviewFilterCountEvent(types: ['vacation']));
        await Future.delayed(const Duration(milliseconds: 500));

        final loadedStates = states.whereType<AbsencesLoaded>().toList();
        expect(loadedStates.last.filterPreviewCount, equals(5));

        verify(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 1,
            types: ['vacation'],
            statuses: null,
            startDate: null,
            endDate: null,
          ),
        ).called(1);

        await subscription.cancel();
        await bloc.close();
      });

      test('ignores preview errors silently', () async {
        when(mockRepository.getMembers()).thenAnswer((_) async => testMembers);
        when(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 10,
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenAnswer((_) async => AbsencesResultModel(testAbsences, 2));

        when(
          mockGetAbsencesUseCase.execute(
            page: 1,
            pageSize: 1,
            types: anyNamed('types'),
            statuses: anyNamed('statuses'),
            startDate: anyNamed('startDate'),
            endDate: anyNamed('endDate'),
          ),
        ).thenThrow(Exception('Preview failed'));

        final bloc = AbsencesBloc(
          getAbsencesUseCase: mockGetAbsencesUseCase,
          getMembersUseCase: mockGetMembersUseCase,
        );

        final states = <AbsencesState>[];
        final subscription = bloc.stream.listen(states.add);

        bloc.add(const LoadAbsencesEvent());
        await Future.delayed(const Duration(milliseconds: 2000));

        final stateCountBefore = states.length;
        bloc.add(const PreviewFilterCountEvent(types: ['vacation']));
        await Future.delayed(const Duration(milliseconds: 500));

        // Should not emit any additional state due to error being ignored
        expect(states.length, equals(stateCountBefore));

        await subscription.cancel();
        await bloc.close();
      });
    });
  });
}
