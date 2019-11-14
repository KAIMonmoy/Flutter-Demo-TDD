import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/core/error/failure.dart';
import 'package:number_trivia/core/platform/network_info.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_remote_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/data/repositories/number_trivia_repository_implementation.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepositoryImplementation repository;
  MockRemoteDataSource mockRemoteDataSource;
  MockLocalDataSource mockLocalDataSource;
  MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockRemoteDataSource();
    mockLocalDataSource = MockLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = NumberTriviaRepositoryImplementation(
      localDataSource: mockLocalDataSource,
      remoteDataSource: mockRemoteDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group(
    'getConcreteNumberTrivia',
    () {
      final tNumber = 1;
      final tNumberTriviaModel = NumberTriviaModel(
        number: tNumber,
        text: 'Test: got num 1',
      );
      final NumberTrivia tNumberTrivia = tNumberTriviaModel;
      test(
        'should check if the defice is online',
        () async {
          // arrange
          when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          // act
          repository.getConcreteNumberTrivia(1);
          // assert
          verify(mockNetworkInfo.isConnected);
        },
      );
      group(
        'device is online',
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
          });

          test(
            'should return remote data when the call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              expect(result, equals(Right(tNumberTrivia)));
            },
          );

          test(
            'should cache the data locally when the call to remote data source is successful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
            },
          );

          test(
            'should return server failure when the call to remote data source is unsuccessful',
            () async {
              // arrange
              when(mockRemoteDataSource.getConcreteNumberTrivia(any))
                  .thenThrow(ServerException());
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
              verifyZeroInteractions(mockLocalDataSource);
              expect(result, equals(Left(ServerFailure())));
            },
          );
        },
      );

      group(
        'device is offline',
        () {
          setUp(() {
            when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
          });
          test(
            'should return last locally cached data when the cached data is present',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenAnswer((_) async => tNumberTriviaModel);
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Right(tNumberTrivia)));
            },
          );

          test(
            'should throw cache failure when the cached data is absent',
            () async {
              // arrange
              when(mockLocalDataSource.getLastNumberTrivia())
                  .thenThrow(CacheException());
              // act
              final result = await repository.getConcreteNumberTrivia(tNumber);
              // assert
              verifyZeroInteractions(mockRemoteDataSource);
              verify(mockLocalDataSource.getLastNumberTrivia());
              expect(result, equals(Left(CacheFailure())));
            },
          );
        },
      );
    },
  );
}
