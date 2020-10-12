import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/data/responses/get_create_service_form_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class GetCreateServiceForm implements UseCase<CreateServiceForm, NoParams> {
  final ProfessionalRepository repository;

  GetCreateServiceForm(this.repository);

  @override
  Future<Either<Failure, CreateServiceForm>> call(NoParams noParams) async {
    return await repository.getCreateServiceForm();
  }
}