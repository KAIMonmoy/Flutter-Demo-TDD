import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:number_trivia/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:number_trivia/features/number_trivia/domain/entities/number_trivia.dart';

import '../../../../core/fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel =
      NumberTriviaModel(number: 1, text: 'Test: 1 what is it?');

  test(
    'should be a subclass of NumberTrivia entity',
    () async {
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'fromJson',
    () {
      test(
        'should return a valid model when the JSON number is an integer',
        () async {
          // arrange
          final Map<String, dynamic> jsonMap =
              json.decode(fixture('trivia.json'));
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          // assert
          expect(result, tNumberTriviaModel);
        },
      );
    },
  );

  group(
    'toJson',
    () {
      test(
        'toJson should return a JSON map containing proper data',
        () async {
          // arrange
          final result = tNumberTriviaModel.toJson();
          // act
          final expectedMap = {
            "text": "Test: 1 what is it?",
            "number": 1,
          };
          // assert
          expect(result, expectedMap);
        },
      );
    },
  );
}
