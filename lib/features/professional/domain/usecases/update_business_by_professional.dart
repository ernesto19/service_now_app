import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class UpdateBusinessByProfessional implements UseCase<RegisterBusinessResponse, UpdateBusinessParams> {
  final ProfessionalRepository repository;

  UpdateBusinessByProfessional(this.repository);

  @override
  Future<Either<Failure, RegisterBusinessResponse>> call(UpdateBusinessParams params) async {
    return await repository.updateBusiness(params.businessId, params.name, params.description, params.industryId, params.categoryId, params.licenseNumber, params.jobOffer, params.latitude, params.longitude, params.address, params.fanpage, params.phone);
  }
}

class UpdateBusinessParams extends Equatable {
  final int businessId;
  final String name;
  final String description;
  final int industryId;
  final int categoryId;
  final String licenseNumber;
  final String jobOffer;
  final String latitude;
  final String longitude;
  final String address;
  final String fanpage;
  final String phone;

  UpdateBusinessParams({ @required this.businessId, @required this.name, @required this.description, @required this.industryId, @required this.categoryId, @required this.licenseNumber, @required this.jobOffer, @required this.latitude, @required this.longitude, @required this.address, @required this.fanpage, @required this.phone });

  @override
  List<Object> get props => [name, description, industryId, categoryId, licenseNumber, jobOffer, latitude, longitude, address, fanpage, phone];
}