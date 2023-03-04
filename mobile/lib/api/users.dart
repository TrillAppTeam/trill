import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// todo update to new api
Future<User?> getCurrUser() async {
  const String tag = '[getCurrUser]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('https://api.trytrill.com/main/users'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return User.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<bool> updateCurrUser({String? bio, String? profilePic, String? nickname}) async {
  const String tag = '[updateCurrUser]';

  safePrint('$tag bio: ${bio ?? 'null'}');
  safePrint('$tag profilePic: ${profilePic ?? 'null'}');
  safePrint('$tag nickname: ${nickname ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.put(
    Uri.parse('https://api.trytrill.com/main/users'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      if (bio != null) 'bio': bio,
      if (profilePic != null) 'profilePicture': profilePic,
      if (nickname != null) 'nickname': nickname,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 200;
}

// this prob needs to change as the api is modified
// username, email, and nickname are useless rn since they're stored in shared preferences
class User {
  final String username;
  final String bio;
  final String email;
  final String nickname;
  final String profilePic;

  const User({
    required this.username,
    required this.bio,
    required this.email,
    required this.nickname,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      bio: json['bio'],
      email: json['email'],
      nickname: json['nickname'],
      profilePic: json['profilePicture'], // note camel case
    );
  }
}
