import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';

/// If no username is passed, get followers for logged in user
Future<List<SpotifyAlbum>?> getFavoriteAlbums([String? username]) async {
  const String tag = '[getFavoriteAlbums]';
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  username ??= prefs.getString('username');
  safePrint('$tag username: $username');

  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/favoritealbums?username=$username'),
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

Future<bool> addFavoriteAlbum(String albumID) async {
  const String tag = '[addFavoriteAlbum]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.post(
    Uri.parse('${Constants.baseURI}/favoritealbums?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 201;
}

Future<bool> deleteFavoriteAlbum(String albumID) async {
  const String tag = '[deleteFavoriteAlbum]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";
  // safePrint('$tag access token: $token');

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/favoritealbums?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag ${response.statusCode}');
  safePrint('$tag ${response.body}');

  return response.statusCode == 200;
}
