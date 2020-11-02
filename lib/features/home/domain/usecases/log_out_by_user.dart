import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';

class LogOutByUser implements UseCase<int, NoParams> {
  final HomeRepository repository;

  LogOutByUser(this.repository);

  @override
  Future<Either<Failure, int>> call(NoParams params) async {
    return await repository.logOut();
  }
}