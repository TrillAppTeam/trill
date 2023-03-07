import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/albums_row.dart';

class HomeScreen extends StatefulWidget {
  final String nickname;

  const HomeScreen({super.key, required this.nickname});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _nickname;

  @override
  void initState() {
    super.initState();
    _nickname = widget.nickname;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hello, $_nickname!',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 36,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          AlbumsRow(
            title: 'Popular Albums This Month',
            albums: List<SpotifyAlbum>.from(
              json
                  .decode(Constants.speakNowAlbums)
                  .map((x) => SpotifyAlbum.fromJson(x)),
            ),
          ),
          const SizedBox(height: 20),
          AlbumsRow(
            title: 'Popular Albums Among Friends',
            albums: List<SpotifyAlbum>.from(
              json
                  .decode(Constants.speakNowAlbums)
                  .map((x) => SpotifyAlbum.fromJson(x)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Recent News',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Hello, Grammys',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Trill Team Favorites',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
