import 'package:flutter/material.dart';

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png'),
            SizedBox(height: 30),
            Text(
              'Please sign in to continue.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                // Log the user in
                Navigator.pushNamed(context, '/home');
              },
            ),
            SizedBox(height: 10),
            Text(
              'Don\'t have an account? Head to the Sign Up page.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
