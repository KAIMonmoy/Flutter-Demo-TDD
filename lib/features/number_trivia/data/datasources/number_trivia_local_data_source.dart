import 'dart:convert';

import 'package:number_trivia/core/error/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

import '../models/number_trivia_model.dart';

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaToCache);
}

class NumberTriviaLocalDataSourceImplementation
    implements NumberTriviaLocalDataSource {
  final SharedPreferences localDataSource;

  NumberTriviaLocalDataSourceImplementation({@required this.localDataSource});

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = localDataSource.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null)
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    throw CacheException();
  }

  @override
  Future<bool> cacheNumberTrivia(NumberTriviaModel triviaToCache) {
    return localDataSource.setString(
        CACHED_NUMBER_TRIVIA, json.encode(triviaToCache.toJson()));
  }
}
