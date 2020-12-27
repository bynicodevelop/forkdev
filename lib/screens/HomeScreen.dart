import 'package:flutter/material.dart';
import 'package:forkdev/screens/ProfileScreen.dart';
import 'package:forkdev/screens/navigationbar/Home.dart';
import 'package:forkdev/screens/navigationbar/Profiles.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _list = List<Widget>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();

    _list.addAll([
      Home(),
      Profiles(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image(
          image: AssetImage('assets/images/name.png'),
          width: 150.0,
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
      body: _list.elementAt(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (value) => setState(() => _currentIndex = value),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Tab1',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Tab2',
          ),
        ],
      ),
    );
  }
}
