import 'package:flutter/material.dart';

class LikedAlbumsScreen extends StatelessWidget {
  const LikedAlbumsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Likes'),
      ),
    );
  }
}
