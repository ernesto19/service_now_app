import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';
import 'package:service_now/core/error/failures.dart';
import 'package:dartz/dartz.dart';
import 'package:service_now/core/usecases/usecase.dart';
import 'package:service_now/features/home/domain/entities/message.dart';
import 'package:service_now/features/home/domain/usecases/get_messages_by_user.dart';
import 'message_event.dart';
import 'message_state.dart';

class MessageBloc extends Bloc<MessageEvent, MessageState> {
  final GetMessagesByUser getMessagesByUser;

  MessageBloc({
    @required GetMessagesByUser getMessages,
  }) : assert(getMessages != null),
       getMessagesByUser = getMessages;

  @override
  MessageState get initialState => MessageState.inititalState;

  @override
  Stream<MessageState> mapEventToState(MessageEvent event) async* {
    if (event is GetMessagesForUser) {
      final failureOrMessages = await getMessagesByUser(NoParams());
      yield* _eitherLoadedOrErrorState(failureOrMessages);
    }
  }

  Stream<MessageState> _eitherLoadedOrErrorState(
    Either<Failure, List<Message>> failureOrMessages
  ) async * {
    yield failureOrMessages.fold(
      (failure) {
        return this.state.copyWith(status: MessageStatus.error);
      },
      (messages) {
        return this.state.copyWith(status: MessageStatus.ready, messages: messages);
      }
    );
  }

  static MessageBloc of(BuildContext context) {
    return BlocProvider.of<MessageBloc>(context);
  }
}