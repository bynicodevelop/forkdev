import 'package:flutter/material.dart';
import 'package:flutter_api_services/flutter_api_services.dart';
import 'package:forkdev/screens/SplashScreen.dart';
import 'package:flutter_mobile_camera/CameraBuilder.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:forkdev/services/AppLocalizationsService.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CameraBuilder(
      child: ApiServices(
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Fork Dev',
          localizationsDelegates: [
            AppLocalizationsService.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('en', 'US'),
            const Locale('fr', 'FR'),
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (var supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale.languageCode &&
                  supportedLocale.countryCode == locale.countryCode) {
                return supportedLocale;
              }
            }

            return supportedLocales.first;
          },
          theme: ThemeData(
            textTheme: TextTheme(
              headline1: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.black,
                    fontSize: 60.0,
                    fontWeight: FontWeight.w200,
                  ),
              headline2: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.black,
                    fontSize: 50.0,
                    fontWeight: FontWeight.w200,
                  ),
              headline3: Theme.of(context).textTheme.headline2.copyWith(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.normal,
                  ),
            ),
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
