import 'package:service_now/features/home/data/models/message_model.dart';

class GetMessagesResponse {
  int error;
  String message;
  List<MessageModel> data = List();

  GetMessagesResponse.fromJson(dynamic json) {
    if (json == null) return;

    error   = json['error'];
    message = json['message'];

    if (error == 0) {
      for (var item in json['data']) {
        final message = MessageModel.fromJson(item);
        data.add(message);
      }
    }
  }
}