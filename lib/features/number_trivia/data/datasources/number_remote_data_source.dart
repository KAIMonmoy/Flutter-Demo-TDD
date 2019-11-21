import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

import '../models/number_trivia_model.dart';

abstract class NumberTriviaRemoteDataSource {
  /// Calls the http://numbersapi.com/:number endpoint.
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number);

  /// Calls the http://numbersapi.com/random endpoint.
  ///
  /// Throws [ServerException] for all error codes.
  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImplementation
    extends NumberTriviaRemoteDataSource {
  final http.Client remoteDataSource;

  NumberTriviaRemoteDataSourceImplementation({@required this.remoteDataSource});

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async {
    final response = await remoteDataSource.get(
      'http://numbersapi.com/$number',
      headers: {'Content-Type': 'application/json'},
    );

    final numberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(response.body));

    return Future.value(numberTriviaModel);
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() {
    // TODO: implement getRandomNumberTrivia
    return null;
  }
}
