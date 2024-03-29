import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_clean_archicture/core/error/failure.dart';

abstract class UseCase<Type,Params> {
  Future<Either<Failure, Type>> call(Params params);
}

class NoParams extends Equatable {}