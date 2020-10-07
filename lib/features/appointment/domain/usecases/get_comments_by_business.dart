import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/repositories/appointment_repository.dart';

class GetCommentsByBusiness implements UseCase<List<Comment>, GetCommentsParams> {
  final AppointmentRepository repository;

  GetCommentsByBusiness(this.repository);

  @override
  Future<Either<Failure, List<Comment>>> call(GetCommentsParams params) async {
    return await repository.getComments(params.businessId);
  }

}

class GetCommentsParams extends Equatable {
  final int businessId;

  GetCommentsParams({ @required this.businessId });

  @override
  List<Object> get props => [businessId];
}