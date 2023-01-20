import 'package:flutter/gestures.dart';
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
              'Please log in to continue.',
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
                Navigator.pushNamed(context, '/main');
              },
            ),
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account? Head to the ',
                style: TextStyle(
                  fontSize: 10,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(color: Color(0xFF3FBCF4)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/signup')),
                  TextSpan(text: ' page.'),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
