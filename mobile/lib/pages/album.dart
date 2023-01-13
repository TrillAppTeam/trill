import 'package:flutter/material.dart';
import '../widgets/bottomnav.dart';

class AlbumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album Name'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}
