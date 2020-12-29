import 'package:flutter/material.dart';
import 'package:flutter_api_services/ChatService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_item_list/widgets/Item.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:forkdev/screens/ChatScreen.dart';
import 'package:provider/provider.dart';

class Messages extends StatefulWidget {
  Messages({Key key}) : super(key: key);

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  UserService _userService;
  ChatService _chatService;

  @override
  void initState() {
    super.initState();

    _userService = Provider.of<UserService>(context, listen: false);
    _chatService = Provider.of<ChatService>(context, listen: false);
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

        return FutureBuilder(
          future: _chatService.lastMessages,
          builder: (context, chatSnapshot) {
            if (chatSnapshot.connectionState != ConnectionState.done) {
              return SizedBox.shrink();
            }

            if (chatSnapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text('No message found'),
                ),
              );
            }

            return Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
              ),
              child: ListView.builder(
                itemCount: chatSnapshot.data.length,
                itemBuilder: (context, index) {
                  return Item(
                    onTap: (uid) async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatScreen(
                            userModel: UserModel(uid: uid),
                          ),
                        ),
                      );

                      setState(() => print('Refreshing view...'));
                    },
                    uid: chatSnapshot.data[index]['user']['uid'],
                    label: chatSnapshot.data[index]['user']['username'],
                    subLabel: chatSnapshot.data[index]['text'],
                    avatarURL: chatSnapshot.data[index]['user']['avatarURL'],
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
