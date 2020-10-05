import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class GetCommentsByBusiness implements UseCase<List<Comment>, Params> {
  final AppointmentRepository repository;

  GetCommentsByBusiness(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(Params params) async {
    return await repository.getComments(params.businessId);
  }

}

class Params extends Equatable {
  final int businessId;

  Params({ @required this.businessId });

  @override
  List<Object> get props => [businessId];
}