import 'package:flutter/material.dart';

// TODO: change this to add trill logo and whatever other ui stuff
class LoadingScreen extends StatelessWidget {
  const LoadingScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Center(child: CircularProgressIndicator());
  }
}
