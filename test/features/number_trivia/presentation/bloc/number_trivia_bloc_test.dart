import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';
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
        inputConverter: mockInputConverter);
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
  });
}
