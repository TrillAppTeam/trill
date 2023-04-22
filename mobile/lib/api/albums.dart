import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

class AlbumsApi {

  Future<DetailedSpotifyAlbum?> getSpotifyAlbum(String albumID) async {
    const String tag = '[getSpotifyAlbum]';

    safePrint('$tag albumID: $albumID');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    final response = await http.get(
      Uri.parse('${Constants.baseURI}/albums?albumID=$albumID'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

    if (response.statusCode == 200) {
      return DetailedSpotifyAlbum.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));
    } else {
      return null;
    }
  }

  Future<List<SpotifyAlbum>?> searchSpotifyAlbums(String query) async {
    const String tag = '[searchSpotifyAlbums]';

    safePrint('$tag query: $query');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    final response = await http.get(
      Uri.parse('${Constants.baseURI}/albums?query=$query'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

    if (response.statusCode == 200) {
      return List<SpotifyAlbum>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((x) => SpotifyAlbum.fromJson(x)));
    } else {
      return null;
    }
  }

  Future<List<SpotifyAlbum>?> getMostPopularAlbums(String timespan) async {
    const String tag = '[getMostPopularAlbums]';

    safePrint('$tag timespan: $timespan');

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? "";

    final response = await http.get(
      Uri.parse('${Constants.baseURI}/albums?timespan=$timespan'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

    if (response.statusCode == 200) {
      return List<SpotifyAlbum>.from(json
          .decode(utf8.decode(response.bodyBytes))
          .map((x) => SpotifyAlbum.fromJson(x)));
    } else if (response.statusCode == 204) {
      return [];
    } else {
      return null;
    }
  }
}

  DateTime parseReleaseDate(String releaseDate) {
    try {
      return DateTime.parse(releaseDate);
    } catch (e) {
      try {
        return DateTime.parse('$releaseDate-01');
      } catch (e) {
        return DateTime.parse('$releaseDate-01-01');
      }
    }
  }


// removed unused fields
class SpotifyAlbum {
  final String name;
  final String id;
  final DateTime releaseDate;
  final List<SpotifyArtist> artists;
  final List<SpotifyImage> images;

  const SpotifyAlbum({
    required this.name,
    required this.id,
    required this.releaseDate,
    required this.artists,
    required this.images,
  });

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) {
    return SpotifyAlbum(
      name: json['name'],
      id: json['id'],
      releaseDate: parseReleaseDate(json['release_date']),
      artists: List<SpotifyArtist>.from(
          json['artists'].map((x) => SpotifyArtist.fromJson(x))),
      images: List<SpotifyImage>.from(
          json['images'].map((x) => SpotifyImage.fromJson(x))),
    );
  }
}

class DetailedSpotifyAlbum extends SpotifyAlbum {
  int averageRating;
  int numRatings;
  bool isReviewed;
  bool isFavorited;
  bool inListenLater;

  DetailedSpotifyAlbum({
    required String name,
    required String id,
    required DateTime releaseDate,
    required List<SpotifyArtist> artists,
    required List<SpotifyImage> images,
    required this.averageRating,
    required this.numRatings,
    required this.isReviewed,
    required this.isFavorited,
    required this.inListenLater,
  }) : super(
          name: name,
          id: id,
          releaseDate: releaseDate,
          artists: artists,
          images: images,
        );

  factory DetailedSpotifyAlbum.fromJson(Map<String, dynamic> json) {
    return DetailedSpotifyAlbum(
      name: json['name'],
      id: json['id'],
      releaseDate: parseReleaseDate(json['release_date']),
      artists: List<SpotifyArtist>.from(
          json['artists'].map((x) => SpotifyArtist.fromJson(x))),
      images: List<SpotifyImage>.from(
          json['images'].map((x) => SpotifyImage.fromJson(x))),
      averageRating: json['average_rating'].round(),
      numRatings: json['num_ratings'],
      isReviewed: json['requestor_reviewed'],
      isFavorited: json['requestor_favorited'],
      inListenLater: json['in_listen_later'],
    );
  }
}

class SpotifyExternalURLs {
  final String spotifyURL;

  const SpotifyExternalURLs({
    required this.spotifyURL,
  });

  factory SpotifyExternalURLs.fromJson(Map<String, dynamic> json) {
    return SpotifyExternalURLs(
      spotifyURL: json['spotify'],
    );
  }
}

class SpotifyImage {
  final String url;
  final int height;
  final int width;

  const SpotifyImage({
    required this.url,
    required this.height,
    required this.width,
  });

  factory SpotifyImage.fromJson(Map<String, dynamic> json) {
    return SpotifyImage(
      url: json['url'],
      height: json['height'],
      width: json['width'],
    );
  }
}

class SpotifyArtist {
  final String name;

  const SpotifyArtist({
    required this.name,
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    return SpotifyArtist(
      name: json['name'],
    );
  }
}
