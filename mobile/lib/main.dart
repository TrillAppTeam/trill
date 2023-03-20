import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trill/pages/confirm.dart';
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
        scaffoldBackgroundColor: const Color(0xFF1A1B29),
        fontFamily: 'Source Sans Pro',
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF374151),
        ),
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            debugLabel: 'whiteMountainView displayLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          displayMedium: TextStyle(
            debugLabel: 'whiteMountainView displayMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          displaySmall: TextStyle(
            debugLabel: 'whiteMountainView displaySmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          headlineLarge: TextStyle(
            debugLabel: 'whiteMountainView headlineLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          headlineMedium: TextStyle(
            debugLabel: 'whiteMountainView headlineMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          headlineSmall: TextStyle(
            debugLabel: 'whiteMountainView headlineSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          titleLarge: TextStyle(
            debugLabel: 'whiteMountainView titleLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          titleMedium: TextStyle(
            debugLabel: 'whiteMountainView titleMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          titleSmall: TextStyle(
            debugLabel: 'whiteMountainView titleSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          bodyLarge: TextStyle(
            debugLabel: 'whiteMountainView bodyLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          bodyMedium: TextStyle(
            debugLabel: 'whiteMountainView bodyMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          bodySmall: TextStyle(
            debugLabel: 'whiteMountainView bodySmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.white70,
            decoration: TextDecoration.none,
          ),
          labelLarge: TextStyle(
            debugLabel: 'whiteMountainView labelLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          labelMedium: TextStyle(
            debugLabel: 'whiteMountainView labelMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
          labelSmall: TextStyle(
            debugLabel: 'whiteMountainView labelSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.white,
            decoration: TextDecoration.none,
          ),
        ),
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
