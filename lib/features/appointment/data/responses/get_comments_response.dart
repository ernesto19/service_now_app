import 'package:service_now/features/appointment/data/models/comment_model.dart';

class GetCommentsResponse {
  int error;
  String message;
  List<CommentModel> data = List();

  GetCommentsResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final comment = CommentModel.fromJson(item);
        data.add(comment);
      }
    }
  }
}