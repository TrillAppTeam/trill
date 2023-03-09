import 'dart:async';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

Future<int?> getLikeCount(int reviewID) async {
  const String tag = '[getLikeCount]';

  safePrint('$tag reviewID: $reviewID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/likes?reviewID=$reviewID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return int.parse(response.body);
  } else {
    return null;
  }
}

Future<bool> likeReview(int reviewID) async {
  const String tag = '[likeReview]';

  safePrint('$tag reviewID: $reviewID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.put(
    Uri.parse('${Constants.baseURI}/likes?reviewID=$reviewID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 201;
}

Future<bool> unlikeReview(int reviewID) async {
  const String tag = '[unlikeReview]';

  safePrint('$tag reviewID: $reviewID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/likes?reviewID=$reviewID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 200;
}

class Like {
  final String username;
  final int reviewID;

  const Like({
    required this.username,
    required this.reviewID,
  });

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      username: json['username'],
      reviewID: json['review_id'],
    );
  }
}
