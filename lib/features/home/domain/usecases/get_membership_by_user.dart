import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/membership.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';

class GetMembershipByUser implements UseCase<Membership, NoParams> {
  final HomeRepository repository;

  GetMembershipByUser(this.repository);

  @override
  Future<Either<Failure, Membership>> call(NoParams params) async {
    return await repository.getMembership();
  }
}