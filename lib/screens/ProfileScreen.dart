import 'package:flutter/material.dart';
import 'package:flutter_api_services/FirestorageService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_manager/enums/TypeField.dart';
import 'package:flutter_profile_manager/flutter_profile_manager.dart';
import 'package:flutter_profile_manager/models/Field.dart';
import 'package:forkdev/helpers/translate.dart';
import 'package:forkdev/screens/AuthScreen.dart';
import 'package:forkdev/services/ProfileService.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  final UserModel userModel;

  ProfileScreen({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, FieldModel> _map = Map<String, FieldModel>();

  ProfileService _profileService;

  UserService _userService;

  @override
  void initState() {
    super.initState();

    FirestorageService firestorageService =
        Provider.of<FirestorageService>(context, listen: false);

    _userService = Provider.of<UserService>(context, listen: false);

    _profileService = ProfileService(
      firestorageService: firestorageService,
      userService: _userService,
    );
  }

  @override
  Widget build(BuildContext context) {
    _map.putIfAbsent(
      UserModel.AVATAR_URL,
      () => FieldModel(
        id: UserModel.AVATAR_URL,
        icon: null,
        label: '',
        defaultValue: widget.userModel.username,
        value: widget.userModel.avatarURL,
        onUpdated: (value) => print(value),
        type: TypeField.AVATAR,
      ),
    );

    _map.putIfAbsent(
      UserModel.EMAIL,
      () => FieldModel(
        id: UserModel.EMAIL,
        icon: Icons.email,
        label: t(context, 'commons.email'),
        value: widget.userModel.email,
        onUpdated: (value) => print(value),
      ),
    );

    _map.putIfAbsent(
      UserModel.USERNAME,
      () => FieldModel(
        id: UserModel.USERNAME,
        icon: Icons.person,
        label: t(context, 'commons.username'),
        value: widget.userModel.username,
        onUpdated: (value) => print(value),
        fieldPlaceholder: t(context, 'commons.enter.username'),
      ),
    );

    _map.putIfAbsent(
      UserModel.STATUS,
      () => FieldModel(
        id: UserModel.STATUS,
        icon: Icons.info,
        label: 'Status',
        value: widget.userModel.status,
        onUpdated: (value) => print(value),
        fieldPlaceholder: t(context, 'commons.enter.status'),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        titleSpacing: 0,
        title: Text(t(context, 'commons.profile').toUpperCase()),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () async {
                  await _userService.signOut();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AuthScreen(),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.exit_to_app,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      t(context, 'commons.logout'),
                    )
                  ],
                ),
              )
            ],
            onSelected: (value) => value(),
          ),
        ],
      ),
      body: ProfileManager(
        onCancled: (FieldModel fieldMode) => null,
        onUpdated: (dynamic value, FieldModel fieldModel) async {
          await _profileService.updateProfile(
              widget.userModel.uid, value, _map[fieldModel.id].id);

          setState(() => _map[fieldModel.id].updateValue = value);
        },
        fields: _map.values.toList(),
      ),
    );
  }
}
