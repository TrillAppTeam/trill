import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<SpotifyAlbum?> getSpotifyAlbum(String albumID) async {
  const String tag = '[getSpotifyAlbum]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('https://api.trytrill.com/main/album?albumID=$albumID'),
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
    Uri.parse('https://api.trytrill.com/main/albums?query=$query'),
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
  final List<SpotifyImages> images;
  final String name;
  final String releaseDate;
  final String type;
  final String uri;
  final List<String> genres;
  final String label;
  final int popularity;
  final List<SpotifyArtists> artists;

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
      images: List<SpotifyImages>.from(
          json['images'].map((x) => SpotifyImages.fromJson(x))),
      name: json['name'],
      releaseDate: json['release_date'],
      type: json['type'],
      uri: json['uri'],
      genres: List<String>.from(json['genres'] ?? []),
      label: json['label'],
      popularity: json['popularity'],
      artists: List<SpotifyArtists>.from(
          json['artists'].map((x) => SpotifyArtists.fromJson(x))),
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

class SpotifyImages {
  final String url;
  final int height;
  final int width;

  const SpotifyImages({
    required this.url,
    required this.height,
    required this.width,
  });

  factory SpotifyImages.fromJson(Map<String, dynamic> json) {
    return SpotifyImages(
      url: json['url'],
      height: json['height'],
      width: json['width'],
    );
  }
}

class SpotifyArtists {
  final String id;
  final String name;
  final String type;
  final String uri;

  const SpotifyArtists({
    required this.id,
    required this.name,
    required this.type,
    required this.uri,
  });

  factory SpotifyArtists.fromJson(Map<String, dynamic> json) {
    return SpotifyArtists(
      id: json['id'],
      name: json['name'],
      type: json['type'],
      uri: json['uri'],
    );
  }
}
