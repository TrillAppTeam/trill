import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/confirm.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/lists/follows.dart';
import 'package:trill/pages/lists/userlists.dart';
import 'package:trill/pages/lists/userreviews.dart';
import 'package:trill/pages/lists/ratedalbums.dart';
import 'package:trill/pages/lists/list.dart';
import 'package:trill/pages/lists/likedreviews.dart';
import 'package:trill/pages/lists/listenlater.dart';
import 'package:trill/pages/splash.dart';

import 'authentication/configure_amplify.dart';

Future<void> main() async {
  // debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await configureAmplify();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

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
        primaryColor: const Color(0xFFBC6AAB),
        scaffoldBackgroundColor: const Color(0x321A1B29),
        fontFamily: 'Source Sans Pro',
        textTheme: Typography.whiteMountainView,
        inputDecorationTheme: const InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3FBCF4),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.fromLTRB(25, 12, 25, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/main': (context) => const MainPage(),
        '/albums': (context) => const RatedAlbumsScreen(),
        '/likes': (context) => const LikedAlbumsScreen(),
        '/reviews': (context) => const UserReviewsScreen(),
        '/list': (context) => const ListScreen(),
        '/lists': (context) => UserListsScreen(),
        '/listenlater': (context) => const ListenLaterScreen(),
        '/login': (context) => const Login(),
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
        return null;
      },
    );
  }
}
