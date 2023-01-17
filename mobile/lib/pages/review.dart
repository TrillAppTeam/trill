import 'package:flutter/material.dart';
import '../widgets/bottomnav.dart';

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Review'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}
