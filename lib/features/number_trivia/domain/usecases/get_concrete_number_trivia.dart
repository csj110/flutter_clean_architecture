import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
import 'package:flutter_clean_archicture/core/usecases/usecase.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/repositories/number_trivia_repository.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, int> {
  final NumberTriviaRepository repository;

  GetConcreteNumberTrivia(this.repository);

  @override
  Future<Either<Failure, NumberTrivia>> call(
    int number,
  ) async {
    return repository.getConcreteNumberTrivia(number);
  }
}
