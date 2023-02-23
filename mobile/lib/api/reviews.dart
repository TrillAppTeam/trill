import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/likes.dart';

Future<Review?> getUserReview(String username, String albumID) async {
  const String tag = '[getUserReview]';

  safePrint('$tag username: $username');
  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse(
        'https://api.trytrill.com/main/reviews?username=$username&album_id=$albumID'),
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

Future<List<Review>?> getAlbumReviews(String sort, String albumID) async {
  const String tag = '[getAlbumReviews]';

  safePrint('$tag sort: $sort');
  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse(
        'https://api.trytrill.com/main/reviews?sort=$sort&album_id=$albumID'),
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

Future<bool> createOrUpdateReview(String username, String albumID, int rating,
    [String? reviewText]) async {
  const String tag = '[createOrUpdateReview]';

  safePrint('$tag username: $username');
  safePrint('$tag albumID: $albumID');
  safePrint('$tag rating: $rating');
  safePrint('$tag reviewText: ${reviewText ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.put(
    Uri.parse('https://api.trytrill.com/main/reviews'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'username': username,
      'album_id': albumID,
      'rating': rating,
      if (reviewText != null) 'review_text': reviewText,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

// prob want to add/change api in backend for deleting by review ID
Future<bool> deleteReview(String username, String albumID) async {
  const String tag = '[deleteReview]';

  safePrint('$tag username: $username');
  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  safePrint('$tag access token: $token');

  final response = await http.delete(
    Uri.parse('https://api.trytrill.com/main/reviews'),
    headers: {
      'Authorization': 'Bearer $token',
    },
    body: jsonEncode(<String, dynamic>{
      'username': username,
      'album_id': albumID,
    }),
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

class Review {
  final int reviewID;
  final String username;
  final String albumID;
  final int rating;
  final String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Like> likes;

  const Review({
    required this.reviewID,
    required this.username,
    required this.albumID,
    required this.rating,
    required this.reviewText,
    required this.createdAt,
    required this.updatedAt,
    required this.likes,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      reviewID: json['review_id'],
      username: json['username'],
      albumID: json['album_id'],
      rating: json['rating'],
      reviewText: json['review_text'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likes: List<Like>.from(json['likes'].map((x) => Like.fromJson(x))),
    );
  }
}