import 'package:flutter/material.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:forkdev/screens/SplashScreen.dart';
import 'package:flutter_mobile_camera/CameraBuilder.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CameraBuilder(
      child: ApiServices(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fork Dev',
          theme: ThemeData(
            primaryColor: Color(0xff143C56),
            buttonTheme: ButtonThemeData(
              buttonColor: Color(0xff143C56),
            ),
          ),
          home: SplashScreen(),
        ),
      ),
    );
  }
}
