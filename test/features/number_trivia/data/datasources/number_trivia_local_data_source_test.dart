import 'dart:convert';

import 'package:mockito/mockito.dart';
import 'package:matcher/matcher.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/core/error/exceptions.dart';
import 'package:number_trivia/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImplementation localDataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    localDataSource = NumberTriviaLocalDataSourceImplementation(
        localDataSource: mockSharedPreferences);
  });

  group(
    'getLastNumber',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
      test(
        'should return NumberTrivia from SharedPreferences when there is one in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any))
              .thenReturn(fixture('trivia_cache.json'));
          // act
          final result = await localDataSource.getLastNumberTrivia();
          // assert
          verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
          expect(result, equals(tNumberTriviaModel));
        },
      );

      test(
        'should throw CacheException when there is nothing in the cache',
        () async {
          // arrange
          when(mockSharedPreferences.getString(any)).thenReturn(null);
          // act
          final call = localDataSource.getLastNumberTrivia;
          // assert
          expect(() => call(), throwsA(TypeMatcher<CacheException>()));
        },
      );
    },
  );

  group(
    'cacheNumberTrivia',
    () {
      final tNumberTriviaModel =
          NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));

      test(
        'should call SharedPreference to cache the data',
        () async {
          // act
          localDataSource.cacheNumberTrivia(tNumberTriviaModel);
          // assert
          verify(mockSharedPreferences.setString(
              CACHED_NUMBER_TRIVIA, json.encode(tNumberTriviaModel.toJson())));
        },
      );
    },
  );
}
