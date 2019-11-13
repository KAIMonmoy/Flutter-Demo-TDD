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
