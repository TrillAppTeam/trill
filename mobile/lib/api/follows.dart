import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<List<Follow>> getFollowers(String username) async {
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
    return List<Follow>.from(
        json.decode(response.body).map((x) => Follow.fromJson(x)));
  } else {
    throw Exception('Failed to load followers');
  }
}

Future<List<Follow>> getFollowing(String username) async {
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
    return List<Follow>.from(
        json.decode(response.body).map((x) => Follow.fromJson(x)));
  } else {
    throw Exception('Failed to load following');
  }
}

Future<bool> createFollow(String followee, String following) async {
  const String tag = '[createFollow]';

  safePrint('$tag followee: $followee');
  safePrint('$tag following: $following');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.post(
    Uri.parse('https://api.trytrill.com/main/follows'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'followee': followee,
      'following': following,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

Future<bool> deleteFollow(String followee, String following) async {
  const String tag = '[createFollow]';

  safePrint('$tag followee: $followee');
  safePrint('$tag following: $following');
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.delete(
    Uri.parse('https://api.trytrill.com/main/follows'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, String>{
      'followee': followee,
      'following': following,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

class Follow {
  final String followee;
  final String following;

  const Follow({
    required this.followee,
    required this.following,
  });

  factory Follow.fromJson(Map<String, dynamic> json) {
    // todo: lowercase json keys once backend is changed
    return Follow(
      followee: json['Followee'],
      following: json['Following'],
    );
  }
}
