import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
import 'package:flutter_clean_archicture/core/usecases/usecase.dart';
import 'package:flutter_clean_archicture/core/util/input_converter.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/usecases/gete_random_number_trivia.dart';
import './bloc.dart';
import 'package:meta/meta.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';
const String CACHE_FAILURE_MESSAGE = 'Cache Failure';
const String INVALID_INPUT_FAILURE_MESSAGE = 'Invalid Input';

class NumberTriviaBloc extends Bloc<NumberTriviaEvent, NumberTriviaState> {
  final GetConcreteNumberTrivia getConcreteNumberTrivia;
  final GetRandomNumberTrivia getRandomNumberTrivia;
  final InputConverter inputConverter;

  NumberTriviaBloc({
    @required GetConcreteNumberTrivia concrete,
    @required GetRandomNumberTrivia random,
    @required this.inputConverter,
  })  : assert(concrete != null),
        assert(random != null),
        assert(inputConverter != null),
        getConcreteNumberTrivia = concrete,
        getRandomNumberTrivia = random;

  @override
  NumberTriviaState get initialState => Empty();

  @override
  Stream<NumberTriviaState> mapEventToState(
    NumberTriviaEvent event,
  ) async* {
    if (event is GetTriviaForConcreteNumber) {
      final inputEither =
          inputConverter.stringToUnsignedInterger(event.numebrString);

      yield* inputEither.fold((failure) async* {
        yield Error(message: INVALID_INPUT_FAILURE_MESSAGE);
      }, (interger) async* {
        yield Loading();
        final result = await getConcreteNumberTrivia(interger);
        yield _handleEitherResult(result);
      });
    } else if (event is GetTriviaForRandomNumber) {
      yield Loading();
      final result = await getRandomNumberTrivia(NoParams());
      yield _handleEitherResult(result);
    }
  }

  NumberTriviaState _handleEitherResult(Either<Failure, NumberTrivia> result) {
    return result.fold(
      (failure) => Error(message: _mapFailureToMessage(failure)),
      (trivia) => Loaded(trivia: trivia),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
        break;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
        break;
      default:
        return "Unecpected error";
    }
  }
}
