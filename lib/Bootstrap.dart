import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:forkdev/screens/HomeScreen.dart';
import 'package:forkdev/screens/WizardScreen.dart';
import 'package:forkdev/screens/widgets/LoadingIndicator.dart';
import 'package:provider/provider.dart';

class Bootstrap extends StatefulWidget {
  const Bootstrap({
    Key key,
  }) : super(key: key);

  @override
  _BootstrapState createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  UserService _userService;

  Widget _widget = Scaffold(
    body: LoadingIndicator(),
  );

  @override
  void initState() {
    super.initState();

    _userService = Provider.of<UserService>(context, listen: false);

    _userService.user.listen((userModel) {
      if (userModel.username == null) {
        setState(
          () => _widget = WizardScreen(
            userModel: userModel,
          ),
        );
      } else {
        setState(
          () => _widget = HomeScreen(
            userModel: userModel,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }
}
