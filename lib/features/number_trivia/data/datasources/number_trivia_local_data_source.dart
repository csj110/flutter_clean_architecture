import 'dart:convert';

import 'package:flutter_clean_archicture/core/error/exception.dart';
import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meta/meta.dart';

const String CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

abstract class NumberTriviaLocalDataSource {
  /// get the cached [NumberTriviamodel] from the local database
  ///
  /// throw a [CacheException] if there is no data;
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivialModel);
}

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl({@required this.sharedPreferences});

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivialModel) {
    final jsonString =json.encode(numberTrivialModel.toJson()) ;
    return sharedPreferences.setString(CACHED_NUMBER_TRIVIA, jsonString);
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    final jsonString = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (jsonString != null)
      return Future.value(NumberTriviaModel.fromJson(json.decode(jsonString)));
    else
      throw CacheException();
  }
}
