import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

Future<List<User>?> searchUsers(String query) async {
  const String tag = '[searchUsers]';

  safePrint('$tag query: $query');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/users?search=$query'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return List<User>.from(
        json.decode(response.body).map((x) => User.fromJson(x)));
  } else {
    return null;
  }
}

Future<DetailedUser?> getDetailedUser([String? username]) async {
  const String tag = '[getPublicUser]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  username ??= prefs.getString('username');
  safePrint('$tag username: $username');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/users?username=$username'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return DetailedUser.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

// idk what file type we need so we can change it
Future<bool> updateCurrUser(
    {String? nickname, String? bio, File? profilePic}) async {
  const String tag = '[updateCurrUser]';

  safePrint(
      '$tag bio: ${bio ?? 'null'}; profilePic: ${profilePic != null ? profilePic.path : 'null'}; nickname: ${nickname ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final request = http.MultipartRequest(
    'PUT',
    Uri.parse('${Constants.baseURI}/users'),
  );

  request.headers.addAll({
    'Authorization': 'Bearer $token',
  });

  if (nickname != null) {
    request.fields['nickname'] = nickname;
  }
  if (bio != null) {
    request.fields['bio'] = bio;
  }
  // will prob need to change constructor here; not tested
  if (profilePic != null) {
    request.files.add(
      http.MultipartFile.fromBytes('file', await profilePic.readAsBytes()),
    );
  }

  final response = await request.send();
  final body = await response.stream.transform(utf8.decoder).join();

  safePrint('$tag Status: ${response.statusCode}; Body: $body');

  return response.statusCode == 200;
}

// Future<bool> updateCurrUser(
//     {String? bio, String? profilePic, String? nickname}) async {
//   const String tag = '[updateCurrUser]';

//   safePrint(
//       '$tag bio: ${bio ?? 'null'}; profilePic: ${profilePic ?? 'null'}; nickname: ${nickname ?? 'null'}');

//   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   String token = prefs.getString('token') ?? "";

//   final response = await http.put(
//     Uri.parse('${Constants.baseURI}/users'),
//     headers: {
//       'Authorization': 'Bearer $token',
//     },
//     body: jsonEncode(<String, dynamic>{
//       if (bio != null) 'bio': bio,
//       if (profilePic != null) 'profile_picture': profilePic,
//       if (nickname != null) 'nickname': nickname,
//     }),
//   );

//   safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

//   return response.statusCode == 200;
// }

// this is dumb lol
String validateProfilePicURL(String profilePicURL) {
  return profilePicURL.startsWith('https://trill-content.s3.amazonaws.com')
      ? profilePicURL
      : "";
}

/// Used for search results
class User {
  final String username;
  final String nickname;
  final String bio;
  final String profilePicURL;

  const User({
    required this.username,
    required this.nickname,
    required this.bio,
    required this.profilePicURL,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      username: json['username'],
      nickname: json['nickname'],
      bio: json['bio'],
      profilePicURL: validateProfilePicURL(json['profile_picture']),
    );
  }
}

/// Used for profile pages
class DetailedUser extends User {
  int following;
  int followers;
  bool requestorFollows;
  bool followsRequestor;
  final int reviewCount;

  DetailedUser({
    required String username,
    required String nickname,
    required String bio,
    required String profilePicURL,
    required this.following,
    required this.followers,
    required this.requestorFollows,
    required this.followsRequestor,
    required this.reviewCount,
  }) : super(
          username: username,
          nickname: nickname,
          bio: bio,
          profilePicURL: profilePicURL,
        );

  factory DetailedUser.fromJson(Map<String, dynamic> json) {
    return DetailedUser(
      username: json['username'],
      bio: json['bio'],
      nickname: json['nickname'],
      profilePicURL: validateProfilePicURL(json['profile_picture']),
      following: List<User>.from(json['following'].map((x) => User.fromJson(x)))
          .length,
      followers: List<User>.from(json['followers'].map((x) => User.fromJson(x)))
          .length,
      requestorFollows: json['requestor_follows'],
      followsRequestor: json['follows_requestor'],
      reviewCount: json['review_count'],
    );
  }
}
