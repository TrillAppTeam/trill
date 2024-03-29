import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/users.dart';
import 'package:trill/constants.dart';

import 'albums.dart';

/// Get an album review from a user - returns for current user if not specified
Future<Review?> getReview(String albumID, [String? username]) async {
  const String tag = '[getReview]';

  safePrint('$tag username: ${username ?? 'null'}; albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

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

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return Review.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
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

  safePrint('$tag sort: $sort; albumID: $albumID; following: $following');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

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

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return List<Review>.from(json
        .decode(utf8.decode(response.bodyBytes))
        .map((x) => Review.fromJson(x)));
  } else {
    return null;
  }
}

/// Get all reviews from a user - returns for current user if not specified
Future<List<DetailedReview>?> getReviews(String sort,
    [String? username]) async {
  const String tag = '[getReviews]';

  safePrint('$tag username: ${username ?? 'null'}; sort: $sort');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

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

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return List<DetailedReview>.from(json
        .decode(utf8.decode(response.bodyBytes))
        .map((x) => DetailedReview.fromJson(x)));
  } else {
    return null;
  }
}

Future<List<DetailedReview>?> getFriendsFeed() async {
  const String tag = '[getFriendsFeed]';

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/reviews?sort=newest&following=true'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  if (response.statusCode == 200) {
    return List<DetailedReview>.from(json
        .decode(utf8.decode(response.bodyBytes))
        .map((x) => DetailedReview.fromJson(x)));
  } else {
    return null;
  }
}

Future<bool> createOrUpdateReview(String albumID, int rating,
    [String? reviewText]) async {
  const String tag = '[createOrUpdateReview]';

  safePrint(
      '$tag albumID: $albumID; rating: $rating; reviewText: ${reviewText ?? 'null'}');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

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

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 201;
}

Future<bool> deleteReview(String albumID) async {
  const String tag = '[deleteReview]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/reviews?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 200;
}

class Review {
  final int reviewID;
  final User user;
  final String albumID;
  int rating;
  String reviewText;
  final DateTime createdAt;
  final DateTime updatedAt;
  int likes;
  bool isLiked;

  Review({
    required this.reviewID,
    required this.user,
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
      user: User.fromJson(json['user']),
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

class DetailedReview extends Review {
  final SpotifyAlbum album;

  DetailedReview({
    required int reviewID,
    required User user,
    required String albumID,
    required int rating,
    required String reviewText,
    required DateTime createdAt,
    required DateTime updatedAt,
    required int likes,
    required bool isLiked,
    required this.album,
  }) : super(
          reviewID: reviewID,
          user: user,
          albumID: albumID,
          rating: rating,
          reviewText: reviewText,
          createdAt: createdAt,
          updatedAt: updatedAt,
          likes: likes,
          isLiked: isLiked,
        );

  factory DetailedReview.fromJson(Map<String, dynamic> json) {
    return DetailedReview(
      reviewID: json['review_id'],
      user: User.fromJson(json['user']),
      albumID: json['album_id'],
      rating: json['rating'],
      reviewText: json['review_text'].trim(),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      likes: json['likes'],
      isLiked: json['requestor_liked'],
      album: SpotifyAlbum.fromJson(json['album']),
    );
  }
}
