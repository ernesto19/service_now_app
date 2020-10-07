import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:meta/meta.dart';

class CommentModel extends Comment {
  CommentModel({
    @required int id, 
    @required String comment, 
    @required String rating, 
    @required String createdAt
  }) : super(id: id, comment: comment, rating: rating, createdAt: createdAt) ;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id:         json['id'], 
      comment:    json['comment'],
      rating:     json['rate'].toString(),
      createdAt:  json['created_at']
    );
  }
}