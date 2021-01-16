import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:socialm/addimage.dart';
import 'package:socialm/homepage.dart';
import 'package:socialm/mainpage.dart';

class BottamNavy extends StatefulWidget {
  @override
  _BottamNavyState createState() => _BottamNavyState();
}

class _BottamNavyState extends State<BottamNavy> {
  int currentIndex = 2;
  final List<Widget> _children = [
    MainPage(),
    AddImage(),
    ProfilePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[currentIndex],
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: currentIndex,
        onItemSelected: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(
              icon: Icon(Icons.home),
              title: Text("Home"),
              activeColor: Colors.blue,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              icon: Icon(Icons.add),
              title: Text("Add"),
              activeColor: Colors.blue,
              inactiveColor: Colors.black),
          BottomNavyBarItem(
              icon: Icon(Icons.person),
              title: Text("Profile"),
              activeColor: Colors.blue,
              inactiveColor: Colors.black)
        ],
      ),
    );
  }
}
