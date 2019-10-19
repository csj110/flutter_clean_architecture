import 'package:flutter_clean_archicture/core/util/input_converter.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:dartz/dartz.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group("string to unsigned interger", () {
    test(
        'should retrun an interger when the string represents an unsigned interger',
        () {
      final str = "1";
      final result = inputConverter.stringToUnsignedInterger(str);
      expect(result, Right(1));
    });

    test(
        'should retrun a Failure when the string does not  represent an unsigned interger',
        () {
      final str = "abc";
      final result = inputConverter.stringToUnsignedInterger(str);
      expect(result, Left(InvalidInputFailure()));
    });

    test(
        'should retrun a Failure when the string does not  represent an unsigned interger',
        () {
      final str = "-1";
      final result = inputConverter.stringToUnsignedInterger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
