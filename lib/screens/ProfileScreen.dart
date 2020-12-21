import 'package:flutter/material.dart';
import 'package:flutter_api_services/FirestorageService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/exceptions/AuthenticationException.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_manager/enums/TypeField.dart';
import 'package:flutter_profile_manager/flutter_profile_manager.dart';
import 'package:flutter_profile_manager/models/Field.dart';
import 'package:forkdev/screens/AuthScreen.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Map<String, FieldModel> _map = Map<String, FieldModel>();
  UserService _userService;
  FirestorageService _firestorageService;

  @override
  void initState() {
    super.initState();

    _userService = Provider.of<UserService>(context, listen: false);
    _firestorageService =
        Provider.of<FirestorageService>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text('Profile'),
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
                      'Logout',
                    )
                  ],
                ),
              )
            ],
            onSelected: (value) => value(),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: _userService.user,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.active) {
            return SizedBox.shrink();
          }

          final userModel = snapshot.data;

          _map.putIfAbsent(
            UserModel.AVATAR_URL,
            () => FieldModel(
              id: UserModel.AVATAR_URL,
              icon: null,
              label: '',
              defaultValue: userModel.username,
              value: userModel.avatarURL,
              onUpdated: (value) => print(value),
              type: TypeField.AVATAR,
            ),
          );

          _map.putIfAbsent(
            UserModel.EMAIL,
            () => FieldModel(
              id: UserModel.EMAIL,
              icon: Icons.email,
              label: 'Email',
              value: userModel.email,
              onUpdated: (value) => print(value),
            ),
          );

          _map.putIfAbsent(
            UserModel.USERNAME,
            () => FieldModel(
                id: UserModel.USERNAME,
                icon: Icons.person,
                label: 'Username',
                value: userModel.status,
                onUpdated: (value) => print(value),
                fieldPlaceholder: 'Enter your username'),
          );

          _map.putIfAbsent(
            UserModel.STATUS,
            () => FieldModel(
                id: UserModel.STATUS,
                icon: Icons.info,
                label: 'Status',
                value: userModel.status,
                onUpdated: (value) => print(value),
                fieldPlaceholder: 'Enter something about you'),
          );

          return ProfileManager(
            onCancled: (FieldModel fieldMode) => null,
            onUpdated: (dynamic value, FieldModel fieldModel) async {
              if (_map[fieldModel.id].id == UserModel.AVATAR_URL) {
                value = await _firestorageService.uploadAvatar(
                    value, userModel.uid);
              }

              try {
                await _userService.update(_map[fieldModel.id].id, value);
              } on AuthenticationException catch (e) {
                print(e.code);
              }

              _map[fieldModel.id].updateValue = value;

              setState(() => print('refresh view...'));
            },
            fields: _map.values.toList(),
          );
        },
      ),
    );
  }
}
