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
        appBarTheme: AppBarTheme(
          backgroundColor: const Color(0xFF2A2B39),
          titleTextStyle: TextStyle(
            color: Colors.grey[300],
            fontSize: 20,
            fontFamily: 'Source Sans Pro',
            fontWeight: FontWeight.w900,
            letterSpacing: .5,
          ),
        ),
        dividerTheme: const DividerThemeData(thickness: 1),
        textTheme: TextTheme(
          displayLarge: TextStyle(
            debugLabel: 'whiteMountainView displayLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          displayMedium: TextStyle(
            debugLabel: 'whiteMountainView displayMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          displaySmall: TextStyle(
            debugLabel: 'whiteMountainView displaySmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          headlineLarge: TextStyle(
            debugLabel: 'whiteMountainView headlineLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          headlineMedium: TextStyle(
            debugLabel: 'whiteMountainView headlineMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          headlineSmall: TextStyle(
            debugLabel: 'whiteMountainView headlineSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          titleLarge: TextStyle(
            debugLabel: 'whiteMountainView titleLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          titleMedium: TextStyle(
            debugLabel: 'whiteMountainView titleMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          titleSmall: TextStyle(
            debugLabel: 'whiteMountainView titleSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          bodyLarge: TextStyle(
            debugLabel: 'whiteMountainView bodyLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          bodyMedium: TextStyle(
            debugLabel: 'whiteMountainView bodyMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          bodySmall: TextStyle(
            debugLabel: 'whiteMountainView bodySmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          labelLarge: TextStyle(
            debugLabel: 'whiteMountainView labelLarge',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          labelMedium: TextStyle(
            debugLabel: 'whiteMountainView labelMedium',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
          labelSmall: TextStyle(
            debugLabel: 'whiteMountainView labelSmall',
            fontFamily: 'Source Sans Pro',
            color: Colors.grey[200],
            decoration: TextDecoration.none,
            letterSpacing: .2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.grey[200]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF3FBCF4),
            foregroundColor: Colors.black,
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              letterSpacing: .4,
              fontWeight: FontWeight.w700,
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
