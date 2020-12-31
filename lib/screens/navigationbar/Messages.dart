import 'package:flutter/material.dart';
import 'package:flutter_api_services/ChatService.dart';
import 'package:flutter_item_list/widgets/MessageItem.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:forkdev/screens/ChatScreen.dart';
import 'package:forkdev/screens/widgets/LoadingIndicator.dart';
import 'package:forkdev/transitions/FadeRouteTransition.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  final UserModel userModel;

  Messages({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  ChatService _chatService;

  @override
  void initState() {
    super.initState();

    _chatService = Provider.of<ChatService>(context, listen: false);

    _chatService.formUid = widget.userModel.uid;
  }

  Future<void> _refresh() async => setState(() => print('Refreshing view...'));

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: FutureBuilder(
        future: _chatService.lastMessages,
        builder: (context, chatSnapshot) {
          if (chatSnapshot.connectionState != ConnectionState.done) {
            return LoadingIndicator();
          }

          if (chatSnapshot.data.length == 0) {
            return Container(
              child: Center(
                child: Text('No message found'),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(
              top: 10.0,
            ),
            itemCount: chatSnapshot.data.length,
            itemBuilder: (context, index) {
              return MessageItem(
                onTap: (uid) async {
                  await Navigator.push(
                    context,
                    FadeRouteTransition(
                      page: ChatScreen(
                        currentUserModel: widget.userModel,
                        userModel: UserModel(
                          uid: uid,
                          username: chatSnapshot.data[index]['user']
                              ['username'],
                          avatarURL: chatSnapshot.data[index]['user']
                              ['avatarURL'],
                        ),
                      ),
                    ),
                  );
                },
                uid: chatSnapshot.data[index]['user']['uid'],
                label: chatSnapshot.data[index]['user']['username'],
                subLabel: chatSnapshot.data[index]['text'],
                avatarURL: chatSnapshot.data[index]['user']['avatarURL'],
                sendAt: chatSnapshot.data[index]['sendAt'],
              );
            },
          );
        },
      ),
    );
  }
}
