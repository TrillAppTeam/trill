import 'dart:async';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// !! this page is not used but kept for reference
final amplifyAuthProvider = Provider<AmplifyAuth>((ref) => AmplifyAuth());
final authUserProvider = FutureProvider<String>((ref) {
  final amplifyAuth = ref.watch(amplifyAuthProvider);
  return amplifyAuth.user.then((value) => value);
});

class AmplifyAuth {
  Future<String> get user async {
    try {
      final currentUser = await Amplify.Auth.getCurrentUser();
      return currentUser.userId;
    } on Exception {
      return Future.error("Not signed in");
    }
  }

  Future<void> signUp(
      String email, String username, String nickname, String password) async {
    try {
      final CognitoSignUpOptions options =
          CognitoSignUpOptions(userAttributes: {
        CognitoUserAttributeKey.email: email,
        CognitoUserAttributeKey.nickname: nickname,
      });
      await Amplify.Auth.signUp(
          username: username, password: password, options: options);
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> confirmSignUp(String username, String confirmationCode) async {
    try {
      await Amplify.Auth.confirmSignUp(
          username: username, confirmationCode: confirmationCode);
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> signIn(String username, String password) async {
    try {
      await Amplify.Auth.signIn(username: username, password: password);
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }

  Future<void> logOut() async {
    try {
      await Amplify.Auth.signOut();
    } on AuthException catch (e) {
      safePrint(e.message);
    }
  }
}
