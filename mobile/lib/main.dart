import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/confirm.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/lists/rated_albums.dart';
import 'package:trill/pages/lists/liked_reviews.dart';
import 'package:trill/pages/lists/listen_later.dart';
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
      // avoiding named routes since it's harder to see errors in navigation
      // and i think named routes are mainly for if you want paths for a website
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
