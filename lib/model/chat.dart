import 'package:equatable/equatable.dart';

class ChatData extends Equatable {
  final int unreadMessages;
  final String chatId;
  final String time;
  final String lastMessage;

  ChatData(
      {this.lastMessage = '',
      this.time = '',
      this.unreadMessages = 0,
      this.chatId = ''});

  @override
  List<Object> get props => [unreadMessages, time, lastMessage, chatId];
}
