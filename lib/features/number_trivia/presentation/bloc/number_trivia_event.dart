import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  NumberTriviaEvent([List props = const <dynamic>[]]) : super(props);
}

class GetTriviaForConcreteNumber extends NumberTriviaEvent {
  final String numebrString;

  GetTriviaForConcreteNumber(this.numebrString) : super([numebrString]);

}

class GetTriviaForRandomNumber extends NumberTriviaEvent {
  
}