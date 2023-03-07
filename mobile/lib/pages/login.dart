import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:trill/mainpage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  SignupData? _signupData;
  bool _isSignedIn = false;

  @override
  void initState() {
    super.initState();
    _logOut();
  }

  void _logOut() async {
    try {
      await Amplify.Auth.signOut();
    } catch (e) {
      safePrint(e);
    }
  }

  Future<String?> _onLogin(BuildContext context, LoginData data) async {
    try {
      final res = await Amplify.Auth.signIn(
        username: data.name,
        password: data.password,
      );
      _isSignedIn = res.isSignedIn;
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  // don't feel like doing this lol
  // Future<String> _onRecoverPassword(
  //     BuildContext context, String username) async {
  //   try {
  //     final res = await Amplify.Auth.resetPassword(username: username);
  //     if (res.nextStep.updateStep == 'CONFIRM_RESET_PASSWORD_WITH_CODE') {
  //       Navigator.of(context).pushReplacementNamed(
  //         '/confirm-reset',
  //         arguments: LoginData(name: username, password: ''),
  //       );
  //     }
  //     return null;
  //   } on AuthException catch (e) {
  //     return e.message;
  //   }
  // }

  Future<String?> _onSignup(BuildContext context, SignupData data) async {
    try {
      await Amplify.Auth.signUp(
        username: data.name!,
        password: data.password!,
        options: CognitoSignUpOptions(
          userAttributes: {
            CognitoUserAttributeKey.email: data.additionalSignupData!['Email']!,
            CognitoUserAttributeKey.nickname:
                data.additionalSignupData!['Nickname']!,
          },
        ),
      );
      _signupData = data;
      return null;
    } on AuthException catch (e) {
      return e.message;
    }
  }

  static String? usernameValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username cannot be empty';
    }
    return null;
  }

  static String? passwordValidator(String? value) {
    // https://stackoverflow.com/a/21456918
    // special character list from cognito console: ^$*.[]{}()?-"!@#%&/\,><':;|_~`+ =
    if (value == null || value.isEmpty || value.length < 8) {
      return 'Password must contain at least 8 characters';
    } else if (!value.contains(RegExp(r'[a-z]'))) {
      return 'Password must contain a lowercase letter';
    } else if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain an uppercase letter';
    } else if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain a number';
    } else if (!value.contains(
        RegExp(r'''[\^$*.\[\]{}\(\)?\-"!@#%&\/\\,><\':;|_~`+= ]'''))) {
      return 'Password must contain a special character';
    } else if (value.startsWith(' ') || value.endsWith(' ')) {
      return 'Password must not begin or end with a space';
    }
    return null;
  }

  static String? nicknameValidator(String? value) {
    if (value == null || value.isEmpty || !Regex.nickname.hasMatch(value)) {
      return 'Name must only contain letters';
    }
    return null;
  }

  static String? emailValidator(String? value) {
    if (value == null || value.isEmpty || !Regex.email.hasMatch(value)) {
      return 'Invalid email';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      logo: const AssetImage('images/logo.png'),
      onLogin: (data) => _onLogin(context, data),
      onRecoverPassword: (_) => Future.value(),
      // if u forget ur password too bad
      // onRecoverPassword: (username) => _onRecoverPassword(context, username),
      onSignup: (data) => _onSignup(context, data),
      theme: LoginTheme(
        primaryColor: const Color(0xFF1F1D36),
        accentColor: const Color(0xFF3FBCF4),
        buttonStyle: const TextStyle(
          color: Colors.black,
        ),
        cardTheme: const CardTheme(
          color: Color(0xFFEEEEEE),
          elevation: 5,
          margin: EdgeInsets.only(top: 15),
        ),
        inputTheme: const InputDecorationTheme(
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAAAAAA), width: 3),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Color(0xFFAAAAAA), width: 3),
          ),
          iconColor: Color(0xFF3FBCF4),
          focusColor: Color(0xFF3FBCF4),
        ),
        buttonTheme: LoginButtonTheme(
          backgroundColor: const Color(0xFF3FBCF4),
          highlightColor: const Color(0xFF1F9CD4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        authButtonPadding: const EdgeInsets.fromLTRB(25, 20, 25, 10),
      ),
      onSubmitAnimationCompleted: () {
        if (!_isSignedIn) {
          Navigator.of(context).pushReplacementNamed(
            '/confirm',
            arguments: _signupData,
          );
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const MainPage(),
            ),
          );
        }
      },
      userType: LoginUserType.name,
      userValidator: (value) => usernameValidator(value),
      passwordValidator: (value) => passwordValidator(value),
      messages: LoginMessages(
        additionalSignUpFormDescription:
            'Please provide your name and email for confirmation',
        userHint: 'Username',
        confirmPasswordError: 'Passwords do not match',
      ),
      additionalSignupFields: [
        UserFormField(
          keyName: 'Nickname',
          icon: const Icon(Icons.face),
          displayName: 'Name',
          fieldValidator: (value) => nicknameValidator(value),
        ),
        UserFormField(
          keyName: 'Email',
          icon: const Icon(Icons.mail_outline),
          fieldValidator: (value) => emailValidator(value),
        ),
      ],
    );
  }
}

class Regex {
  // https://stackoverflow.com/a/69111624
  static final nickname = RegExp(r'^[A-Za-z]+$');
  // https://stackoverflow.com/a/32686261/9449426
  static final email = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
}
