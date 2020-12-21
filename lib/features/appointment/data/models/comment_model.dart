import 'package:service_now/features/appointment/domain/entities/comment.dart';
import 'package:meta/meta.dart';

class CommentModel extends Comment {
  CommentModel({
    @required int id, 
    @required String firstName, 
    @required String lastName, 
    @required String comment, 
    @required String rating, 
    @required String createdAt
  }) : super(id: id, firstName: firstName, lastName: lastName, comment: comment, rating: rating, createdAt: createdAt) ;

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id:         json['id'], 
      firstName:  json['client_first_name'] ?? '',
      lastName:   json['client_last_name'] ?? '',
      comment:    json['comment'] ?? '',
      rating:     json['rating'].toString(),
      createdAt:  json['created_at']
    );
  }
}