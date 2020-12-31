import 'package:flutter/material.dart';
import 'package:flutter_api_services/UserService.dart';
import 'package:flutter_models/models/UserModel.dart';
import 'package:forkdev/screens/ProfileScreen.dart';
import 'package:forkdev/screens/navigationbar/Contacts.dart';
import 'package:forkdev/screens/navigationbar/Messages.dart';
import 'package:forkdev/screens/navigationbar/Profiles.dart';
import 'package:forkdev/screens/widgets/LoadingIndicator.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  final UserModel userModel;

  const HomeScreen({
    Key key,
    this.userModel,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserService _userService;

  final List<String> _titles = List<String>();
  final List<Widget> _widgets = List<Widget>();

  int _currentIndex = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();

    _userService = Provider.of<UserService>(context, listen: false);

    _titles.addAll([
      'Messages',
      'Contacts',
      'Profiles',
    ]);

    _userService.user.listen((userModel) {
      _widgets.addAll([
        Messages(userModel: userModel),
        Contacts(userModel: userModel),
        Profiles(userModel: userModel),
      ]);

      setState(() => _loading = !_loading);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: 'logo',
              child: Image(
                image: AssetImage('assets/images/logo.png'),
                width: 30.0,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                bottom: 3.0,
              ),
              child: Text(_titles.elementAt(_currentIndex).toUpperCase()),
            )
          ],
        ),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: () async {
                  final UserModel userModel = await _userService.user.first;

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(userModel: userModel),
                    ),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.black,
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      'Profile',
                    )
                  ],
                ),
              )
            ],
            onSelected: (value) => value(),
          ),
        ],
      ),
      body: !_loading ? _widgets.elementAt(_currentIndex) : LoadingIndicator(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_rounded),
            label: 'Messages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contacts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Profiles',
          ),
        ],
      ),
    );
  }
}
