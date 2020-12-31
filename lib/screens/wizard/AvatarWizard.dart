import 'package:flutter/material.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:flutter_profile_avatar/flutter_profile_avatar.dart';

class AvatarWizard extends StatelessWidget {
  final UserModel userModel;
  final Function(String, String) onSave;

  const AvatarWizard({
    Key key,
    this.onSave,
    this.userModel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: ProfileAvatar(
            size: 70.0,
            onUpdated: (path) async {
              await onSave(UserModel.AVATAR_URL, path);
              Navigator.pop(context);
            },
          ),
        ),
      ],
    );
  }
}
