import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_card/flutter_profile_card.dart';
import 'package:provider/provider.dart';

class PublicProfileScreen extends StatefulWidget {
  final UserModel userModel;

  const PublicProfileScreen({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
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
    print('PublicProfileScreen => userModel ${widget.userModel.toJson()}');

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _userService.user,
        builder: (context, userSnapshot) {
          if (userSnapshot.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }

          return StreamBuilder(
            stream: _usersService.getUserProfile(widget.userModel.uid),
            builder: (context, snapshotUserModel) {
              if (snapshotUserModel.connectionState != ConnectionState.active) {
                return SizedBox.shrink();
              }

              dynamic result =
                  snapshotUserModel.data.followersList.firstWhere((e) {
                return e['ref'].id == userSnapshot.data.uid;
              }, orElse: () => null);

              snapshotUserModel.data.isFollow = result != null;

              return ProfileCard(
                profile: snapshotUserModel.data,
                onFollowed: (profile) async {
                  UserModel userModel = await _userService.user.first;

                  await _usersService.updateRelations(
                      userModel.uid, snapshotUserModel.data.uid);
                },
              );
            },
          );
        },
      ),
    );
  }
}
