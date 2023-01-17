import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png'),
            SizedBox(height: 50),
            Text(
              'Welcome to Trill',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Track albums you\'ve listened to. Save those you want to hear.'
              ' Tell your friends what\'s good.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              child: Text('Get Started'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    ));
  }
}
