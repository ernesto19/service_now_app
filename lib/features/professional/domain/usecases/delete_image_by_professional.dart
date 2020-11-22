import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/professional/data/responses/delete_image_response.dart';
import 'package:service_now/features/professional/domain/repositories/professional_repository.dart';

class DeleteImageByProfessional implements UseCase<DeleteImageResponse, DeleteParams> {
  final ProfessionalRepository repository;

  DeleteImageByProfessional(this.repository);

  @override
  Future<Either<Failure, DeleteImageResponse>> call(DeleteParams params) async {
    return await repository.deleteImage(params.id);
  }
}

class DeleteParams extends Equatable {
  final int id;

  DeleteParams({ @required this.id });

  @override
  List<Object> get props => [id];
}