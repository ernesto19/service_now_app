import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/message.dart';
import 'package:service_now/features/home/domain/repositories/home_repository.dart';

class GetMessagesByUser implements UseCase<List<Message>, NoParams> {
  final HomeRepository repository;

  GetMessagesByUser(this.repository);

  @override
  Future<Either<Failure, List<Message>>> call(NoParams params) async {
    return await repository.getMessages();
  }
}