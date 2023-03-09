import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

/// If no username is passed, get followers for logged in user
Future<Follow?> getFollowers([String? username]) async {
  const String tag = '[getFollowers]';
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  username ??= prefs.getString('username');
  safePrint('$tag username: $username');

  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse(
        '${Constants.baseURI}/follows?type=getFollowers&username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return Follow.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

/// If no username is passed, get following for logged in user
Future<Follow?> getFollowing([String? username]) async {
  const String tag = '[getFollowing]';
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  username ??= prefs.getString('username');
  safePrint('$tag username: $username');

  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse(
        '${Constants.baseURI}/follows?type=getFollowing&username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return Follow.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<bool> follow(String userToFollow) async {
  const String tag = '[follow]';

  safePrint('$tag userToFollow: $userToFollow');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.post(
    Uri.parse('${Constants.baseURI}/follows?username=$userToFollow'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 201;
}

Future<bool> unfollow(String userToUnfollow) async {
  const String tag = '[unfollow]';

  safePrint('$tag userToUnfollow: $userToUnfollow');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/follows?username=$userToUnfollow'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 200;
}

// Followee follows the following
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
