import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';

abstract class NumberTriviaRepository {
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int number);
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia();
}
