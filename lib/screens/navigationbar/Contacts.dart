import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:forkdev/screens/ChatScreen.dart';
import 'package:provider/provider.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  UserService _userService;
  UsersService _usersService;

  @override
  void initState() {
    super.initState();
    _userService = Provider.of<UserService>(context, listen: false);
    _usersService = Provider.of<UsersService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.user,
      builder: (context, user) {
        if (user.connectionState != ConnectionState.active) {
          return SizedBox.shrink();
        }

        return FutureBuilder(
          future: _usersService.getUsersByReference(user.data.followersList),
          builder: (context, users) {
            if (users.connectionState != ConnectionState.done) {
              return SizedBox.shrink();
            }

            if (users.data.length == 0) {
              return Container(
                child: Center(
                  child: Text('No contacts found'),
                ),
              );
            }

            return ProfileList(
              onTap: (profile) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userModel: profile,
                    ),
                  )),
              profiles: users.data.toList(),
            );
          },
        );
      },
    );
  }
}
