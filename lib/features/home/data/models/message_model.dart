import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/entities/message.dart';

class MessageModel extends Message {
  MessageModel({
    @required int id,
    @required String content,
    @required String createdAt
  }) : super(id: id, content: content, createdAt: createdAt);

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'], 
      content: json['content'], 
      createdAt: json['created_at']
    );
  }
}