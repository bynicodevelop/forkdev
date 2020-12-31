import 'package:flutter/material.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_card/flutter_profile_card.dart';
import 'package:forkdev/helpers/translate.dart';
import 'package:provider/provider.dart';

class PublicProfileScreen extends StatefulWidget {
  final UserModel currentUserModel;
  final UserModel userModel;

  const PublicProfileScreen({
    Key key,
    @required this.currentUserModel,
    this.userModel,
  }) : super(key: key);

  @override
  _PublicProfileScreenState createState() => _PublicProfileScreenState();
}

class _PublicProfileScreenState extends State<PublicProfileScreen> {
  UsersService _usersService;

  @override
  void initState() {
    super.initState();
    _usersService = Provider.of<UsersService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _usersService.getUserProfile(widget.userModel.uid),
        builder: (context, snapshotUserModel) {
          if (snapshotUserModel.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }

          dynamic result = snapshotUserModel.data.followersList.firstWhere((e) {
            return e['ref'].id == widget.currentUserModel.uid;
          }, orElse: () => null);

          snapshotUserModel.data.isFollow = result != null;

          return ProfileCard(
            profile: snapshotUserModel.data,
            onFollowed: (profile) async {
              await _usersService.updateRelations(
                  widget.currentUserModel.uid, snapshotUserModel.data.uid);
            },
            aboutLabel: t(context, "ProfileCard.about.label"),
          );
        },
      ),
    );
  }
}
