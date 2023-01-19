import 'package:flutter/material.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/album.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/review.dart';
import 'package:trill/pages/signup.dart';
import 'package:trill/pages/splash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trill',
      theme: ThemeData(
        primaryColor: Color(0xFFBC6AAB),
        scaffoldBackgroundColor: Color(0xFF1A1B29),
        textTheme: Typography.whiteMountainView,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF3FBCF4),
            foregroundColor: Colors.black,
            padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LogInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/main': (context) => MainPage(),
        '/album': (context) => AlbumScreen(),
        '/review': (context) => ReviewScreen(),
      },
    );
  }
}
