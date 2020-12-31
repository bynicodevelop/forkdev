import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:forkdev/screens/PublicProfileScreen.dart';
import 'package:forkdev/screens/widgets/LoadingIndicator.dart';
import 'package:forkdev/transitions/FadeRouteTransition.dart';
import 'package:provider/provider.dart';

class Profiles extends StatefulWidget {
  final UserModel userModel;

  const Profiles({
    Key key,
    this.userModel,
  }) : super(key: key);

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
    return FutureBuilder(
      future: _usersService.get(),
      builder: (context, usersSnapshot) {
        if (usersSnapshot.connectionState != ConnectionState.done) {
          return LoadingIndicator();
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
                currentUserModel: widget.userModel,
                userModel: profile,
              ),
            ),
          ),
          profiles: usersSnapshot.data
              .where((user) => user.username != null)
              .where((user) => user.status != null)
              .where((user) => user.uid != widget.userModel.uid)
              .toList(),
        );
      },
    );
  }
}
