import 'package:flutter/material.dart';
import '../widgets/bottomnav.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username\'s Profile'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}
