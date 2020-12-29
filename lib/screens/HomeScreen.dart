import 'package:flutter/material.dart';
import 'package:forkdev/screens/ProfileScreen.dart';
import 'package:forkdev/screens/navigationbar/Contacts.dart';
import 'package:forkdev/screens/navigationbar/Messages.dart';
import 'package:forkdev/screens/navigationbar/Profiles.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _titles = List<String>();
  final List<Widget> _widgets = List<Widget>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _titles.addAll([
      'Messages',
      'Contacts',
      'Profiles',
    ]);

    _widgets.addAll([
      Messages(),
      Contacts(),
      Profiles(),
    ]);
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProfileScreen(),
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
      body: _widgets.elementAt(_currentIndex),
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
