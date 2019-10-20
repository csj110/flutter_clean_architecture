import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
import 'package:flutter_clean_archicture/core/usecases/usecase.dart';
import 'package:flutter_clean_archicture/core/util/input_converter.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/usecases/get_concrete_number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/domain/usecases/gete_random_number_trivia.dart';
import 'package:flutter_clean_archicture/features/number_trivia/presentation/bloc/bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

class MockGetConcreteNumberTrivia extends Mock
    implements GetConcreteNumberTrivia {}

class MockGetRandomNumberTrivia extends Mock implements GetRandomNumberTrivia {}

class MockInputConverter extends Mock implements InputConverter {}

void main() {
  NumberTriviaBloc bloc;
  MockGetConcreteNumberTrivia mockGetConcreteNumberTrivia;
  MockGetRandomNumberTrivia mockGetRandomNumberTrivia;
  MockInputConverter mockInputConverter;

  setUp(() {
    mockGetConcreteNumberTrivia = MockGetConcreteNumberTrivia();
    mockGetRandomNumberTrivia = MockGetRandomNumberTrivia();
    mockInputConverter = MockInputConverter();

    bloc = NumberTriviaBloc(
      concrete: mockGetConcreteNumberTrivia,
      random: mockGetRandomNumberTrivia,
      inputConverter: mockInputConverter,
    );
  });

  test('initialState will be Empty', () {
    expect(bloc.initialState, Empty());
  });

  group("get triviaNumber for concrete number", () {
    final tNumberString = '1';
    final tNumber = 1;
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    test(
      "should call the inputConverter to validate and convert the input string to an unsigned",
      () async {
        when(mockInputConverter.stringToUnsignedInterger(any))
            .thenReturn(Right(tNumber));

        bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
        await untilCalled(mockInputConverter.stringToUnsignedInterger(any));
        verify(mockInputConverter.stringToUnsignedInterger(tNumberString));
      },
    );

    test('Should emit [Error] when the input is invalid', () async {
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Left(InvalidInputFailure()));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));

      final expected = [Empty(), Error(message: INVALID_INPUT_FAILURE_MESSAGE)];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );
    });

    test("should get data from concrete usecase", () async {
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
      await untilCalled(mockGetConcreteNumberTrivia(any));

      verify(mockGetConcreteNumberTrivia(tNumber));
    });

    test("should emit [Loading Loaded] when the data is gotten successfully",
        () async {
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test("should emit [Loading Loaded] when fails", () async {
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });

    test("should emit [Loading Loaded] when fails with correct error message ",
        () async {
      when(mockInputConverter.stringToUnsignedInterger(any))
          .thenReturn(Right(tNumber));
      when(mockGetConcreteNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForConcreteNumber(tNumberString));
    });
  });


  group("get triviaNumber for random number", () {
    final tNumberTrivia = NumberTrivia(number: 1, text: "test trivia");

    test("should get data from random usecase", () async {

      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      bloc.dispatch(GetTriviaForRandomNumber());
      await untilCalled(mockGetRandomNumberTrivia(any));

      verify(mockGetRandomNumberTrivia(NoParams()));
    });

    test("should emit [Loading Loaded] when the data is gotten successfully",
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Right(tNumberTrivia));

      final expected = [Empty(), Loading(), Loaded(trivia: tNumberTrivia)];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test("should emit [Loading Loaded] when fails", () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(ServerFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: SERVER_FAILURE_MESSAGE)
      ];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForRandomNumber());
    });

    test("should emit [Loading Loaded] when fails with correct error message ",
        () async {
      when(mockGetRandomNumberTrivia(any))
          .thenAnswer((_) async => Left(CacheFailure()));

      final expected = [
        Empty(),
        Loading(),
        Error(message: CACHE_FAILURE_MESSAGE)
      ];
      expectLater(
        bloc.state,
        emitsInOrder(expected),
      );

      bloc.dispatch(GetTriviaForRandomNumber());
    });
  });
}
