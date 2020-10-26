import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/features/professional/data/responses/register_business_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class RegisterBusinessByProfessional implements UseCase<RegisterBusinessResponse, RegisterBusinessParams> {
  final ProfessionalRepository repository;

  RegisterBusinessByProfessional(this.repository);

  @override
  Future<Either<Failure, RegisterBusinessResponse>> call(RegisterBusinessParams params) async {
    return await repository.registerBusiness(params.name, params.description, params.industryId, params.categoryId, params.licenseNumber, params.jobOffer, params.latitude, params.longitude, params.address, params.fanpage, params.images);
  }
}

class RegisterBusinessParams extends Equatable {
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
  final List<Asset> images;

  RegisterBusinessParams({ @required this.name, @required this.description, @required this.industryId, @required this.categoryId, @required this.licenseNumber, @required this.jobOffer, @required this.latitude, @required this.longitude, @required this.address, @required this.fanpage, @required this.images });

  @override
  List<Object> get props => [name, description, industryId, categoryId, licenseNumber, jobOffer, latitude, longitude, address, fanpage];
}