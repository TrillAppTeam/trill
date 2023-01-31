import 'package:flutter/material.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/review.dart';
import 'package:trill/pages/signup.dart';
import 'package:trill/pages/splash.dart';
import 'package:trill/pages/lists/album.dart';
import 'package:trill/pages/lists/followers.dart';
import 'package:trill/pages/lists/following.dart';
import 'package:trill/pages/lists/userlists.dart';
import 'package:trill/pages/lists/userreviews.dart';
import 'package:trill/pages/lists/ratedalbums.dart';
import 'package:trill/pages/lists/list.dart';
import 'package:trill/pages/lists/likedalbums.dart';
import 'package:trill/pages/lists/listenlater.dart';
import 'package:trill/pages/user.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trill',
      theme: ThemeData(
        primaryColor: Color(0xFFBC6AAB),
        scaffoldBackgroundColor: Color(0x321A1B29),
        fontFamily: 'Source Sans Pro',
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
        '/albums': (context) => RatedAlbumsScreen(),
        '/likes': (context) => LikedAlbumsScreen(),
        '/review': (context) => WriteReviewScreen(),
        '/reviews': (context) => UserReviewsScreen(),
        '/list': (context) => ListScreen(),
        '/lists': (context) => UserListsScreen(),
        '/listenlater': (context) => ListenLaterScreen(),
        '/followers': (context) => FollowersScreen(),
        '/following': (context) => FollowingScreen(),
        '/user': (context) => UserScreen(),
      },
    );
  }
}
