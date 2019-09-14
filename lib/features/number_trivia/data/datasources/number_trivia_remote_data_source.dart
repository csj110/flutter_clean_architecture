import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRemoteDataSource {
  ///calls the http://numbersapi.com/{number} endpoint.
  ///
  ///Throw a [ServerException] for all errors.
  Future<NumberTrivia> getConcreteNumberTrivia(int number);

  /// call the http://numbersapi.com/random endpoint.
  /// 
  /// throw a [ServerException] for all errors. 
  Future<NumberTrivia> getRandomNumberTrivia();
}
