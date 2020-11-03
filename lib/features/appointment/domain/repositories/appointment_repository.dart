import 'package:dartz/dartz.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:service_now/features/appointment/data/responses/request_business_response.dart';
import 'package:service_now/features/appointment/domain/entities/business.dart';
import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:service_now/features/appointment/domain/entities/gallery.dart';

abstract class AppointmentRepository {
  Future<Either<Failure, List<Business>>> getBusiness(int categoryId, String latitude, String longitude);
  Future<Either<Failure, List<Comment>>> getComments(int businessId);
  Future<Either<Failure, List<Gallery>>> getGalleries(int businessId);
  Future<Either<Failure, RequestBusinessResponse>> requestBusiness(int businessId);
}