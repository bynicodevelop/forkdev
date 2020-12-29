import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:forkdev/screens/AuthScreen.dart';
import 'package:forkdev/screens/HomeScreen.dart';
import 'package:forkdev/transitions/FadeRouteTransition.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  StreamSubscription _streamSubscription;

  @override
  void initState() {
    super.initState();

    // UserService _userService = Provider.of<UserService>(context, listen: false);
    // _userService.signOut();

    _streamSubscription =
        Provider.of<UserService>(context, listen: false).user.listen((user) {
      print('SplashScreen => UserModel: ${user?.toJson()}');

      if (context == null) return;

      if (user == null) {
        Navigator.pushReplacement(
          context,
          FadeRouteTransition(
            page: AuthScreen(),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          FadeRouteTransition(
            page: HomeScreen(),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    print('SplashScreen => disposed');
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
            ),
            child: Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 150.0,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 20.0,
              horizontal: 20.0,
            ),
            child: Image(
              image: AssetImage('assets/images/name.png'),
              width: 300.0,
            ),
          )
        ],
      ),
    );
  }
}
