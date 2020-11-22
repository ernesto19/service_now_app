import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Message extends Equatable {
  final int id;
  final String content;
  final String createdAt;

  Message({
    @required this.id,
    @required this.content,
    @required this.createdAt
  });

  @override
  List<Object> get props => [id, content, createdAt];
}