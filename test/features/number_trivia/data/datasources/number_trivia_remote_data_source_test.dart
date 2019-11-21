import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:number_trivia/features/number_trivia/data/datasources/number_remote_data_source.dart';

import '../../../../core/fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSourceImplementation
      numberTriviaRemoteDataSourceImplementation;
  MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    numberTriviaRemoteDataSourceImplementation =
        NumberTriviaRemoteDataSourceImplementation(
            remoteDataSource: mockHttpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;

    test(
      '''should perform a GET request on a URL 
      with number being the endpoint
      and with application/json header''',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
            (_) async => http.Response(fixture('trivia.json'), 200));
        // act
        numberTriviaRemoteDataSourceImplementation
            .getConcreteNumberTrivia(tNumber);
        // assert
        verify(
          mockHttpClient.get(
            'http://numbersapi.com/$tNumber',
            headers: {'Content-Type': 'application/json'},
          ),
        );
      },
    );
  });
}
