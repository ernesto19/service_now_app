import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/domain/entities/professional_business.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class GetProfessionalBusinessByProfessional implements UseCase<List<ProfessionalBusiness>, NoParams> {
  final ProfessionalRepository repository;

  GetProfessionalBusinessByProfessional(this.repository);

  @override
  Future<Either<Failure, List<ProfessionalBusiness>>> call(NoParams params) async {
    return await repository.getProfessionalBusiness();
  }
}