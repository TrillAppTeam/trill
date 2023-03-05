import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/constants.dart';

Future<SpotifyAlbum?> getSpotifyAlbum(String albumID) async {
  const String tag = '[getSpotifyAlbum]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/album?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return SpotifyAlbum.fromJson(jsonDecode(response.body));
  } else {
    return null;
  }
}

Future<List<SpotifyAlbum>?> searchSpotifyAlbums(String query) async {
  const String tag = '[searchSpotifyAlbums]';

  safePrint('$tag query: $query');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/albums?query=$query'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  if (response.statusCode == 200) {
    return List<SpotifyAlbum>.from(
        json.decode(response.body).map((x) => SpotifyAlbum.fromJson(x)));
  } else {
    return null;
  }
}

class SpotifyAlbum {
  final String albumType;
  final SpotifyExternalURLs externalURLs;
  final String href;
  final String id;
  final List<SpotifyImage> images;
  final String name;
  final DateTime releaseDate;
  final String type;
  final String uri;
  final List<String> genres;
  final String label;
  final int popularity;
  final List<SpotifyArtist> artists;

  const SpotifyAlbum({
    required this.albumType,
    required this.externalURLs,
    required this.href,
    required this.id,
    required this.images,
    required this.name,
    required this.releaseDate,
    required this.type,
    required this.uri,
    required this.genres,
    required this.label,
    required this.popularity,
    required this.artists,
  });

  factory SpotifyAlbum.fromJson(Map<String, dynamic> json) {
    return SpotifyAlbum(
      albumType: json['album_type'],
      externalURLs: SpotifyExternalURLs.fromJson(json['external_urls']),
      href: json['href'],
      id: json['id'],
      images: List<SpotifyImage>.from(
          json['images'].map((x) => SpotifyImage.fromJson(x))),
      name: json['name'],
      releaseDate: DateTime.parse(json['release_date']),
      type: json['type'],
      uri: json['uri'],
      genres: List<String>.from(json['genres'] ?? []),
      label: json['label'],
      popularity: json['popularity'],
      artists: List<SpotifyArtist>.from(
          json['artists'].map((x) => SpotifyArtist.fromJson(x))),
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
  final String id;
  final String name;
  final String type;
  final String uri;

  const SpotifyArtist({
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory SpotifyArtist.fromJson(Map<String, dynamic> json) {
    return SpotifyArtist(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}
