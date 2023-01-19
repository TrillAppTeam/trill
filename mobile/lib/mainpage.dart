import 'package:flutter/material.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/pages/search.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;
  final screens = [
    HomeScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack keeps the states of each page
      body: IndexedStack(
        index: currentIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Color(0xFFBC6AAB).withOpacity(.2),
              blurRadius: 15,
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: Color(0xFF1A1B29),
          selectedItemColor: Color(0xFFBC6AAB),
          unselectedItemColor: Color(0xFF888888),
          showUnselectedLabels: false,
          iconSize: 30,
          elevation: 10,
          currentIndex: currentIndex,
          onTap: (index) {
            setState(() {
              currentIndex = index;
            });
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: '____',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search_outlined),
              activeIcon: Icon(Icons.search),
              label: '____',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_outlined),
              activeIcon: Icon(Icons.person),
              label: '____',
            ),
          ],
        ),
      ),
    );
  }
}
