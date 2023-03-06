import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

Future<List<User>?> searchUsers(String query) async {
  const String tag = '[searchUsers]';

  safePrint('$tag query: $query');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/users?search=$query'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return List<User>.from(
        json.decode(response.body).map((x) => User.fromJson(x)));
  } else {
    return null;
  }
}

Future<PublicUser?> getPublicUser([String? username]) async {
  const String tag = '[getPublicUser]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  username ??= prefs.getString('username');
  safePrint('$tag username: $username');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/users?username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return PublicUser.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<PrivateUser?> getPrivateUser() async {
  const String tag = '[getPrivateUser]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/users'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return PrivateUser.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<bool> updateCurrUser(
    {String? bio, String? profilePic, String? nickname}) async {
  const String tag = '[updateCurrUser]';

  safePrint('$tag bio: ${bio ?? 'null'}');
  safePrint('$tag profilePic: ${profilePic ?? 'null'}');
  safePrint('$tag nickname: ${nickname ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.put(
    Uri.parse('${Constants.baseURI}/users'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      if (bio != null) 'bio': bio,
      if (profilePic != null) 'profile_picture': profilePic,
      if (nickname != null) 'nickname': nickname,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 200;
}

// Used for search results
class User {
  final String username;
  final String bio;
  final String profilePic;

  const User({
    required this.username,
    required this.bio,
    required this.profilePic,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      bio: json['bio'],
      profilePic: json['profile_picture'],
    );
  }
}

// Used for profile pages
class PublicUser extends User {
  final String nickname;

  const PublicUser({
    required String username,
    required String bio,
    required String profilePic,
    required this.nickname,
  }) : super(
          username: username,
          bio: bio,
          profilePic: profilePic,
        );

  factory PublicUser.fromJson(Map<String, dynamic> json) {
    return PublicUser(
      username: json['username'],
      bio: json['bio'],
      nickname: json['nickname'],
      profilePic: json['profile_picture'],
    );
  }
}

// username, email, and nickname are stored in shared preferences
class PrivateUser extends PublicUser {
  final String email;

  const PrivateUser({
    required String username,
    required String bio,
    required String nickname,
    required String profilePic,
    required this.email,
  }) : super(
          username: username,
          bio: bio,
          nickname: nickname,
          profilePic: profilePic,
        );

  factory PrivateUser.fromJson(Map<String, dynamic> json) {
    return PrivateUser(
      username: json['username'],
      bio: json['bio'],
      email: json['email'],
      nickname: json['nickname'],
      profilePic: json['profile_picture'],
    );
  }
}
