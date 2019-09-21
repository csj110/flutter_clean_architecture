import 'package:flutter_clean_archicture/features/number_trivia/data/models/number_trivia_model.dart';

abstract class NumberTriviaLocalDataSource {
  /// get the cached [NumberTriviamodel] from the local database
  ///
  /// throw a [CacheException] if there is no data;
  Future<NumberTriviaModel> getLastNumberTrivia();

  ///
  Future<void> cacheNumberTrivia(NumberTriviaModel numberTrivialModel);
}
