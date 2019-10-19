import 'package:dartz/dartz.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInterger(String str) {
    try {
      final result = int.parse(str);
      if (result < 0) {
        throw FormatException();
      }
      return Right(int.parse(str));
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
