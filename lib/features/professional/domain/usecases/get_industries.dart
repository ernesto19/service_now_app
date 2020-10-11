import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/data/responses/get_industries_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class GetIndustries implements UseCase<IndustryCategory, NoParams> {
  final ProfessionalRepository repository;

  GetIndustries(this.repository);

  @override
  Future<Either<Failure, IndustryCategory>> call(NoParams noParams) async {
    return await repository.getIndustries();
  }
}