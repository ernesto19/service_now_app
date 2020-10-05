import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

class Comment extends Equatable {
  final int id;
  final String comment;
  final String rating;
  final String createdAt;

  Comment({
    @required this.id, 
    @required this.comment, 
    @required this.rating, 
    @required this.createdAt
  });

  @override
  List<Object> get props => [id, comment, rating, createdAt];
}