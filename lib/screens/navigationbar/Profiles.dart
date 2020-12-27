import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:forkdev/screens/PublicProfileScreen.dart';
import 'package:provider/provider.dart';

class Profiles extends StatefulWidget {
  const Profiles({Key key}) : super(key: key);

  @override
  _ProfilesState createState() => _ProfilesState();
}

class _ProfilesState extends State<Profiles> {
  UsersService _usersService;
  UserService _userService;

  @override
  void initState() {
    super.initState();
    _usersService = Provider.of<UsersService>(context, listen: false);
    _userService = Provider.of<UserService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _userService.user,
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState != ConnectionState.active) {
          return SizedBox.shrink();
        }

        return FutureBuilder(
          future: _usersService.get(),
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState != ConnectionState.done) {
              return SizedBox.shrink();
            }

            return ProfileList(
              onTap: (profile) => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => PublicProfileScreen(
                            userModel: profile,
                          ))),
              profiles: usersSnapshot.data
                  .where((user) => user.uid != userSnapshot.data.uid)
                  .toList(),
            );
          },
        );
      },
    );
  }
}
