import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';
import 'package:service_now/features/login/data/responses/login_response.dart';

class AcquireMembershipByUser implements UseCase<LoginResponse, NoParams> {
  final HomeRepository repository;

  AcquireMembershipByUser(this.repository);

  @override
  Future<Either<Failure, LoginResponse>> call(NoParams params) async {
    return await repository.acquireMembership();
  }
}