import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

/// Get an album review from a user - returns for current user if not specified
Future<Review?> getReview(String albumID, [String? username]) async {
  const String tag = '[getReview]';

  safePrint('$tag username: ${username ?? 'null'}');
  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  String uri = '${Constants.baseURI}/reviews?albumID=$albumID';
  if (username != null) {
    uri += '&username=$username';
  }

  final response = await http.get(
    Uri.parse(uri),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return Review.fromJson(jsonDecode(response.body));
  } else if (response.statusCode == 204) {
    safePrint('$tag No content; returning null');
    return null;
  } else {
    return null;
  }
}

Future<List<Review>?> getAlbumReviews(
    String sort, String albumID, bool following) async {
  const String tag = '[getAlbumReviews]';

  safePrint('$tag sort: $sort');
  safePrint('$tag albumID: $albumID');
  safePrint('$tag following: $following');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  String uri = '${Constants.baseURI}/reviews?sort=$sort&albumID=$albumID';
  if (following == true) {
    uri += '&following=true';
  }

  final response = await http.get(
    Uri.parse(uri),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return List<Review>.from(
        json.decode(response.body).map((x) => Review.fromJson(x)));
  } else {
    return null;
  }
}

/// Get all reviews from a user - returns for current user if not specified
Future<List<Review>?> getReviews(String sort, [String? username]) async {
  const String tag = '[getReviews]';

  safePrint('$tag username: ${username ?? 'null'}');
  safePrint('$tag sort: $sort');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  String uri = '${Constants.baseURI}/reviews?sort=$sort';
  if (username != null) {
    uri += '&username=$username';
  }

  final response = await http.get(
    Uri.parse(uri),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return List<Review>.from(
        json.decode(response.body).map((x) => Review.fromJson(x)));
  } else {
    return null;
  }
}

Future<List<Review>?> getFriendsFeed() async {
  const String tag = '[getFriendsFeed]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/reviews?sort=newest&following=true'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return List<Review>.from(
        json.decode(response.body).map((x) => Review.fromJson(x)));
  } else {
    return null;
  }
}

Future<bool> createOrUpdateReview(String albumID, int rating,
    [String? reviewText]) async {
  const String tag = '[createOrUpdateReview]';

  safePrint('$tag albumID: $albumID');
  safePrint('$tag rating: $rating');
  safePrint('$tag reviewText: ${reviewText ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.put(
    Uri.parse('${Constants.baseURI}/reviews?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'rating': rating,
      if (reviewText != null && reviewText.isNotEmpty)
        'review_text': reviewText,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

Future<bool> deleteReview(String albumID) async {
  const String tag = '[deleteReview]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/reviews?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 200;
}

class Review {
  // prob need to make some fields not final to modify them?
  final int reviewID;
  final String username;
  final String albumID;
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likes;
  bool isLiked;

  Review({
    required this.reviewID,
    required this.username,
    required this.albumID,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
    required this.isLiked,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewID: json['review_id'],
      username: json['username'],
      albumID: json['album_id'],
      rating: json['rating'],
      reviewText: json['review_text'].trim(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likes: json['likes'],
      isLiked: json['requestor_liked'],
    );
  }
}
