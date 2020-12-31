import 'package:flutter/material.dart';
import 'package:flutter_api_services/FirestorageService.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:forkdev/screens/HomeScreen.dart';
import 'package:forkdev/screens/wizard/AvatarWizard.dart';
import 'package:forkdev/screens/wizard/FinishWizard.dart';
import 'package:forkdev/screens/wizard/StatusWizard.dart';
import 'package:forkdev/screens/wizard/UsernameWizard.dart';
import 'package:forkdev/services/ProfileService.dart';
import 'package:provider/provider.dart';

class WizardScreen extends StatefulWidget {
  final UserModel userModel;

  WizardScreen({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _WizardScreenState createState() => _WizardScreenState();
}

class _WizardScreenState extends State<WizardScreen> {
  final List<Widget> _widgets = List<Widget>();

  UserService _userService;
  int _index = 0;

  ProfileService _profileService;

  Future<void> _onSave(String key, String value) async {
    print('value: $value');
    await _profileService.updateProfile(widget.userModel.uid, value, key);

    setState(() => _index++);

    if (_index == _widgets.length - 1) {
      _userService.user.listen(
        (userModel) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => HomeScreen(
                userModel: userModel,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  void initState() {
    super.initState();

    final FirestorageService firestorageService =
        Provider.of<FirestorageService>(context, listen: false);

    _userService = Provider.of<UserService>(context, listen: false);

    _profileService = ProfileService(
      firestorageService: firestorageService,
      userService: _userService,
    );

    _widgets.addAll([
      UsernameWizard(
        userModel: widget.userModel,
        onSave: _onSave,
      ),
      AvatarWizard(
        userModel: widget.userModel,
        onSave: _onSave,
      ),
      StatusWizard(
        userModel: widget.userModel,
        onSave: _onSave,
      ),
      FinishWizard(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _widgets.elementAt(_index),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20.0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _widgets.asMap().entries.map((entry) {
                      return Icon(
                        Icons.fiber_manual_record,
                        size: 15.0,
                        color: entry.key == _index
                            ? Theme.of(context).primaryColor
                            : Colors.grey[200],
                      );
                    }).toList(),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
