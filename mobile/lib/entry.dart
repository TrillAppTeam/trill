import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trill/amplifyconfiguration.dart';
import 'package:trill/mainpage.dart';
import 'package:trill/pages/login.dart';
import 'package:trill/pages/splash.dart';

class EntryScreen extends StatefulWidget {
  @override
  State<EntryScreen> createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  void initState() {
    super.initState();
    _configureAmplify();
  }

  void _configureAmplify() async {
    try {
      if (!Amplify.isConfigured) {
        await Amplify.addPlugin(AmplifyAuthCognito());
        await Amplify.configure(amplifyconfig);
      }
    } catch (e) {
      safePrint(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // todo: figure out what to do if amplify isn't configured=
    return Scaffold(
      body: Login(),

      // i wanted to check if there was a user logged in and skip the splash screen
      // but it takes too long so everyone's going to the splash screen
      // body: Amplify.isConfigured
      //     ? FutureBuilder<AuthUser>(
      //         future: Amplify.Auth.getCurrentUser(),
      //         builder: (context, snapshot) {
      //           if (snapshot.hasData) {
      //             return Login();
      //           } else {
      //             return SplashScreen();
      //           }
      //         },
      //       )
      //     : Center(
      //         // todo: make trill loading screen while configuring
      //         child: CircularProgressIndicator(),
      //       ),
    );
  }
}
