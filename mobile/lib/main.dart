import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trill/pages/album.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/pages/review.dart';
import 'package:trill/pages/search.dart';
import 'package:trill/pages/signup.dart';
import 'package:trill/pages/splash.dart';
import 'package:trill/widgets/bottomnav.dart';

void main() => runApp(ChangeNotifierProvider(
    create: (context) => TrillBottomNavigatorModel(), child: MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: Typography.whiteMountainView,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LogInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/searchResults': (context) => SearchResultsScreen(),
        '/album': (context) => AlbumScreen(),
        '/review': (context) => ReviewScreen(),
        '/profile': (context) => ProfileScreen()
      },
    );
  }
}
