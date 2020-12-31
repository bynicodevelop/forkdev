import 'package:flutter/material.dart';
import 'package:flutter_api_services/UsersService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_list/flutter_profile_list.dart';
import 'package:forkdev/screens/ChatScreen.dart';
import 'package:forkdev/screens/widgets/LoadingIndicator.dart';
import 'package:forkdev/screens/widgets/NotFound.dart';
import 'package:forkdev/transitions/FadeRouteTransition.dart';
import 'package:provider/provider.dart';

class Contacts extends StatefulWidget {
  final UserModel userModel;

  const Contacts({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  UsersService _usersService;

  @override
  void initState() {
    super.initState();
    _usersService = Provider.of<UsersService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _usersService.getUsersByReference(widget.userModel.followersList),
      builder: (context, users) {
        if (users.connectionState != ConnectionState.done) {
          return LoadingIndicator();
        }

        if (users.data.length == 0) {
          return NoFound(
            label: 'Contacts.label',
          );
        }

        return ProfileList(
          onTap: (profile) async => await Navigator.push(
            context,
            FadeRouteTransition(
              page: ChatScreen(
                currentUserModel: widget.userModel,
                userModel: profile,
              ),
            ),
          ),
          profiles: users.data.toList(),
        );
      },
    );
  }
}
