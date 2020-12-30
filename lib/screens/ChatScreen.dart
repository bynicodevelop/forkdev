import 'package:flutter/material.dart';
import 'package:flutter_api_services/ChatService.dart';
import 'package:flutter_chat_components/flutter_chat_components.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_chat_components/MessageFied.dart';
import 'package:flutter_profile_avatar/flutter_profile_avatar.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  final UserModel currentUserModel;
  final UserModel userModel;

  ChatScreen({
    Key key,
    @required this.currentUserModel,
    @required this.userModel,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  int _nMessages = 0;
  ChatService _chatService;

  @override
  void initState() {
    super.initState();
    _chatService = Provider.of<ChatService>(context, listen: false);

    _chatService.toUid = widget.userModel.uid;
    _chatService.formUid = widget.currentUserModel.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            ProfileAvatar(
              size: 15,
              username: widget.userModel.username,
              avatarURL: widget.userModel.avatarURL,
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
              ),
              child: Text(widget.userModel.username.toUpperCase()),
            ),
          ],
        ),
      ),
      body: StreamBuilder(
        stream: _chatService.messages,
        builder: (context, messagesSnapshot) {
          if (messagesSnapshot.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }

          _nMessages = messagesSnapshot.data.length;

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Chat(
              messages: messagesSnapshot.data,
              currentUserUid: widget.currentUserModel.uid,
            ),
          );
        },
      ),
      bottomNavigationBar: MessageField(
        currentUserUid: widget.currentUserModel.uid,
        onSend: (message) async {
          // // Automatically scroll to the last message sent
          // // if the scrollController is define in the Chat widget
          // _scrollToBottom();

          Map<String, String> pathes =
              await _chatService.sendMessage(message, widget.userModel.uid);

          if (_nMessages == 1) {
            await _chatService.updateProfiles(message.userUid,
                pathes['pathFrom'], widget.userModel.uid, pathes['pathTo']);
          }
        },
      ),
    );
  }
}
