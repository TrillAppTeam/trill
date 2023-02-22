import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// temp copy
Future<void> fetchAuthSession() async {
  try {
    final result = await Amplify.Auth.fetchAuthSession(
      options: CognitoSessionOptions(getAWSCredentials: true),
    );

    final cognitoSession = result as CognitoAuthSession;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', cognitoSession.userPoolTokens!.accessToken);
    safePrint('access token: ${cognitoSession.userPoolTokens!.accessToken}');
  } on AuthException catch (e) {
    safePrint(e.message);
  }
}

Future<List<Follow>> getFollowers(String username) async {
  safePrint('Get Followers - username: $username');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  // idk what im doing
  if (prefs.getString('token') == null) {
    await fetchAuthSession();
  }
  String token = prefs.getString('token') ?? "";
  safePrint('api access token: $token');

  final response = await http.get(
    Uri.parse(
        'https://api.trytrill.com/main/follows?type=getFollowers&username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  if (response.statusCode == 200) {
    safePrint(response.body);
    return List<Follow>.from(
        json.decode(response.body).map((x) => Follow.fromJson(x)));
  } else {
    safePrint(response.statusCode);
    safePrint(response.body);
    throw Exception('Failed to load followers');
  }
}

class Follow {
  final int followee;
  final int following;

  const Follow({
    required this.followee,
    required this.following,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      followee: json['followee'],
      following: json['following'],
    );
  }
}
