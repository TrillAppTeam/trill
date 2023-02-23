import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// todo: change all functions and Follow class to reflect new api changes

Future<Follow?> getFollowers(String username) async {
  const String tag = '[getFollowers]';

  safePrint('$tag username: $username');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse(
        'https://api.trytrill.com/main/follows?type=getFollowers&username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return Follow.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<Follow?> getFollowing(String username) async {
  const String tag = '[getFollowing]';

  safePrint('$tag username: $username');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse(
        'https://api.trytrill.com/main/follows?type=getFollowing&username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return Follow.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

// Followee follows the following
Future<bool> follow(String currUser, String userToFollow) async {
  const String tag = '[createFollow]';

  safePrint('$tag followee: $currUser');
  safePrint('$tag following: $userToFollow');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.post(
    Uri.parse('https://api.trytrill.com/main/follows'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'followee': currUser,
      'following': userToFollow,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

Future<bool> unfollow(String currUser, String userToUnfollow) async {
  const String tag = '[createFollow]';

  safePrint('$tag followee: $currUser');
  safePrint('$tag following: $userToUnfollow');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.delete(
    Uri.parse('https://api.trytrill.com/main/follows'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'followee': currUser,
      'following': userToUnfollow,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

class Follow {
  final List<String> users;

  const Follow({
    required this.users,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    return Follow(
      users: List<String>.from(json['users']),
    );
  }
}
