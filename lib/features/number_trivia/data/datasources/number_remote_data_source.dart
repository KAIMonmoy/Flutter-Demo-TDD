import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:number_trivia/core/error/exceptions.dart';

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

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    final response = await remoteDataSource.get(
      url,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return NumberTriviaModel.fromJson(json.decode(response.body));
    }

    throw ServerException();
  }

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int number) async =>
      await _getTriviaFromUrl('http://numbersapi.com/$number');

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async =>
      await _getTriviaFromUrl('http://numbersapi.com/random');
}
