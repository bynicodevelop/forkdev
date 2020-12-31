import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_api_services/exceptions/AuthenticationException.dart';
import 'package:flutter_auth_form/flutter_auth_form.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:forkdev/helpers/translate.dart';
import 'package:forkdev/screens/HomeScreen.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  AuthScreen({Key key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final GlobalKey<ScaffoldState> _scafflodKey = GlobalKey<ScaffoldState>();

  bool _loading = false;

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
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
            ),
            child: !_loading
                ? AuthForm(
                    title: t(context, 'AuthForm.connexion'),
                    buttonLabel: t(context, 'AuthForm.connexion'),
                    emailLabel: t(context, 'AuthForm.enter.email'),
                    passwordLabel: t(context, 'AuthForm.enter.password'),
                    onPressed: (userModel) async {
                      setState(() => _loading = !_loading);

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
                            _notify(t(context, 'AuthForm.unexepected.error'),
                                'Dissimiss');
                            setState(() => _loading = !_loading);
                          }
                        }

                        if (e.code ==
                            AuthenticationException.WRONG_CREDENTIALS) {
                          setState(() => _loading = !_loading);
                          _notify(t(context, 'AuthForm.wrong.credentials'),
                              'Dissimiss');
                        }

                        if (e.code ==
                            AuthenticationException.TOO_MANY_REQUESTS) {
                          setState(() => _loading = !_loading);
                          _notify(t(context, 'AuthForm.account.blocked'),
                              'Dissimiss');
                        }
                      }
                    },
                  )
                : Column(
                    children: [
                      Text(
                        t(context, 'AuthForm.welcome').toUpperCase(),
                        style: Theme.of(context).textTheme.headline1,
                      ),
                      Text(
                        t(context, 'AuthForm.prepare.space'),
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 40.0,
                        ),
                        child: SpinKitThreeBounce(
                          color: Theme.of(context).primaryColor,
                          size: 15.0,
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
