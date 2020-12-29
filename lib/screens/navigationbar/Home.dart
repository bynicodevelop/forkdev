import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:forkdev/screens/ChatScreen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  UserService _userService;

  @override
  void initState() {
    super.initState();
    _userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.active) {
          return SizedBox.shrink();
        }

        return FutureBuilder(
          future: _userService.getFollowers(snapshot.data.followersList),
          builder: (context, users) {
            if (users.connectionState != ConnectionState.done) {
              return SizedBox.shrink();
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
