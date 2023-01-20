import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('images/logo.png'),
            SizedBox(height: 30),
            Text(
              'Create an account to continue.',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  hintText: "Email",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  hintText: "Username",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))
                ),
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                  hintText: "Password",
                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.6))
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                Navigator.pushNamed(context, '/');
              },
            ),
            SizedBox(height: 15),
            RichText(
              text: TextSpan(
                text: 'Already have an account? Head to the ',
                style: TextStyle(
                  fontSize: 10, color: Color(0xFF3FBCF4)
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'Log In',
                      style: TextStyle(color: Color(0xFFBF40BF)),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Navigator.pushNamed(context, '/login')),
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
