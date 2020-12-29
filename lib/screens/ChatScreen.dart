import 'package:flutter/material.dart';
import 'package:flutter_api_services/ChatService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_chat_components/flutter_chat_components.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_chat_components/MessageFied.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel userModel;

  ChatScreen({
    Key key,
    @required this.userModel,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _nMessages = 0;
  UserService _userService;
  ChatService _chatService;

  @override
  void initState() {
    super.initState();

    _userService = Provider.of<UserService>(context, listen: false);
    _chatService = Provider.of<ChatService>(context, listen: false);

    _chatService.toUid = widget.userModel.uid;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _userService.user,
        builder: (context, user) {
          if (user.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }

          _chatService.formUid = user.data.uid;

          return Scaffold(
            appBar: AppBar(),
            body: StreamBuilder(
              stream: _chatService.messages,
              builder: (context, messagesSnapshot) {
                print(messagesSnapshot.error);
                if (messagesSnapshot.connectionState !=
                    ConnectionState.active) {
                  return SizedBox.shrink();
                }

                _nMessages = messagesSnapshot.data.length;

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10.0,
                  ),
                  child: Chat(
                    messages: messagesSnapshot.data,
                    currentUserUid: user.data.uid,
                  ),
                );
              },
            ),
            bottomNavigationBar: MessageField(
              currentUserUid: user.data.uid,
              onSend: (message) async {
                // // Automatically scroll to the last message sent
                // // if the scrollController is define in the Chat widget
                // _scrollToBottom();

                Map<String, String> pathes = await _chatService.sendMessage(
                    message, widget.userModel.uid);

                if (_nMessages == 1) {
                  await _chatService.updateProfiles(
                      message.userUid,
                      pathes['pathFrom'],
                      widget.userModel.uid,
                      pathes['pathTo']);
                }
              },
            ),
          );
        });
  }
}
