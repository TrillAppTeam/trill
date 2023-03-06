import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/confirm.dart';
import 'package:trill/pages/edit_profile.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/review.dart';
import 'package:trill/pages/lists/album.dart';
import 'package:trill/pages/lists/followers.dart';
import 'package:trill/pages/lists/following.dart';
import 'package:trill/pages/lists/userlists.dart';
import 'package:trill/pages/lists/userreviews.dart';
import 'package:trill/pages/lists/ratedalbums.dart';
import 'package:trill/pages/lists/list.dart';
import 'package:trill/pages/lists/likedalbums.dart';
import 'package:trill/pages/lists/listenlater.dart';
import 'package:trill/pages/splash.dart';
import 'package:trill/pages/user.dart';

import 'authentication/configure_amplify.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      // https://medium.com/@JediPixels/flutter-navigator-pageroutebuilder-transitions-b05991f53069
      // saving this link cuz im gonna forget
      routes: {
        '/main': (context) => MainPage(),
        '/album': (context) => AlbumScreen(),
        '/albums': (context) => RatedAlbumsScreen(),
        '/likes': (context) => LikedAlbumsScreen(),
        '/reviews': (context) => UserReviewsScreen(),
        '/list': (context) => ListScreen(),
        '/lists': (context) => UserListsScreen(),
        '/listenlater': (context) => ListenLaterScreen(),
        '/login': (context) => Login(),
        '/followers': (context) => FollowersScreen(),
        '/following': (context) => FollowingScreen(),
        '/user': (context) => UserScreen(),
        '/editprofile': (context) => EditProfileScreen()
      },
      // used instead of routes to pass arguments to widget
      onGenerateRoute: (settings) {
        if (settings.name == '/confirm') {
          return PageRouteBuilder(
            pageBuilder: (_, __, ___) =>
                ConfirmScreen(settings.arguments as SignupData),
            transitionsBuilder: (_, __, ___, child) => child,
          );
        }
      },
    );
  }
}
