import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/register_service_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class RegisterServiceByProfessional implements UseCase<RegisterServiceResponse, RegisterServiceParams> {
  final ProfessionalRepository repository;

  RegisterServiceByProfessional(this.repository);

  @override
  Future<Either<Failure, RegisterServiceResponse>> call(RegisterServiceParams params) async {
    return await repository.registerService(params.businessId, params.serviceId, params.price, params.images);
  }
}

class RegisterServiceParams extends Equatable {
  final int businessId;
  final int serviceId;
  final double price;
  final List<Asset> images;

  RegisterServiceParams({ @required this.businessId, @required this.serviceId, @required this.price, @required this.images });

  @override
  List<Object> get props => [businessId, serviceId, price];
}