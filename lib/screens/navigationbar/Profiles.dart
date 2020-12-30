import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forkdev/screens/PublicProfileScreen.dart';
import 'package:forkdev/transitions/FadeRouteTransition.dart';
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
          return Container(
            child: Center(
              child: SpinKitThreeBounce(
                color: Theme.of(context).primaryColor,
                size: 15.0,
              ),
            ),
          );
        }

        return FutureBuilder(
          future: _usersService.get(),
          builder: (context, usersSnapshot) {
            if (usersSnapshot.connectionState != ConnectionState.done) {
              return SizedBox.shrink();
            }

            if (usersSnapshot.data.length == 0) {
              return Container(
                child: Center(
                  child: Text('No profile found'),
                ),
              );
            }

            return ProfileList(
              onTap: (profile) => Navigator.push(
                context,
                FadeRouteTransition(
                  page: PublicProfileScreen(
                    currentUserModel: userSnapshot.data,
                    userModel: profile,
                  ),
                ),
                // MaterialPageRoute(
                //   builder: (context) => PublicProfileScreen(
                //     currentUserModel: userSnapshot.data,
                //     userModel: profile,
                //   ),
                // ),
              ),
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
