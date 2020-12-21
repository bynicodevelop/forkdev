import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/exceptions/AuthenticationException.dart';
import 'package:flutter_auth_form/flutter_auth_form.dart';
import 'package:forkdev/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  GlobalKey<ScaffoldState> _scafflodKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    void _notify(String message, String closeMessage) {
      _scafflodKey.currentState.showSnackBar(SnackBar(
        content: Text(message),
        duration: Duration(
          seconds: 4,
        ),
        action: closeMessage != null
            ? SnackBarAction(
                label: closeMessage,
                textColor: Colors.white,
                onPressed: () =>
                    _scafflodKey.currentState.hideCurrentSnackBar(),
              )
            : null,
      ));
    }

    return Scaffold(
      key: _scafflodKey,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
              ),
              child: AuthForm(
                title: 'Connexion',
                buttonLabel: 'Connexion',
                emailLabel: 'Enter your email',
                passwordLabel: 'Enter your password',
                onPressed: (userModel) async {
                  UserService userService =
                      Provider.of<UserService>(context, listen: false);

                  try {
                    await userService.signInWithEmailAndPassword(
                      userModel.email,
                      userModel.password,
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeScreen(),
                      ),
                    );
                  } on AuthenticationException catch (e) {
                    if (e.code == AuthenticationException.USER_NOT_FOUND) {
                      try {
                        await userService.signUpWithEmailAndPassword(
                          userModel.email,
                          userModel.password,
                        );

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => HomeScreen(),
                          ),
                        );
                      } on AuthenticationException catch (e) {
                        print(e.code);
                      }
                    }

                    if (e.code == AuthenticationException.WRONG_CREDENTIALS) {
                      _notify('Wrong credentials', 'Dissimiss');
                    }

                    if (e.code == AuthenticationException.TOO_MANY_REQUESTS) {
                      _notify(
                          'Account blocked: Too many login attempts (try again later)',
                          'Dissimiss');
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
