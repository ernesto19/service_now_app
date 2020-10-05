import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class GetGalleriesByBusiness implements UseCase<List<Gallery>, GetGalleriesParams> {
  final AppointmentRepository repository;

  GetGalleriesByBusiness(this.repository);

  @override
  Future<Either<Failure, List<Gallery>>> call(GetGalleriesParams params) async {
    return await repository.getGalleries(params.businessId);
  }

}

class GetGalleriesParams extends Equatable {
  final int businessId;

  GetGalleriesParams({ @required this.businessId });

  @override
  List<Object> get props => [businessId];
}