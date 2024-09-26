import 'package:cashes/app/core/errors/app_errors.dart';
import 'package:dartz/dartz.dart';

abstract interface class UseCase<SuccessType, Params> {
  Future<Either<Failure, SuccessType>> call(Params params);
}

class NoParams {}
