import 'dart:async';
import 'dart:convert';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';

Future<List<SpotifyAlbum>?> getListenLaterAlbums() async {
  const String tag = '[getListenLaters]';
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  String token = prefs.getString('token') ?? "";

  final response = await http.get(
    Uri.parse('${Constants.baseURI}/listenlateralbums'),
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

Future<bool> addListenLater(String albumID) async {
  const String tag = '[addListenLater]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.post(
    Uri.parse('${Constants.baseURI}/listenlateralbums?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 201;
}

Future<bool> deleteListenLater(String albumID) async {
  const String tag = '[deleteListenLater]';

  safePrint('$tag albumID: $albumID');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  String token = prefs.getString('token') ?? "";

  final response = await http.delete(
    Uri.parse('${Constants.baseURI}/listenlateralbums?albumID=$albumID'),
    headers: {
      'Authorization': 'Bearer $token',
    },
  );

  safePrint('$tag Status: ${response.statusCode}; Body: ${response.body}');

  return response.statusCode == 200;
}
