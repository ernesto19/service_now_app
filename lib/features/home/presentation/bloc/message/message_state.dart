import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:service_now/features/home/domain/entities/message.dart';

enum MessageStatus { checking, loading, selecting, downloading, ready, error }

class MessageState extends Equatable {
  final MessageStatus status;
  final List<Message> messages;

  MessageState({ @required this.status, @required this.messages });

  static MessageState get inititalState => MessageState(
    status: MessageStatus.checking,
    messages: []
  );

  MessageState copyWith({
    MessageStatus status,
    List<Message> messages
  }) {
    return MessageState(
      status: status ?? this.status,
      messages: messages ?? this.messages
    );
  }

  @override
  List<Object> get props => [status, messages];

}