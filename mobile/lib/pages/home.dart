import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/albums_row.dart';
import 'package:trill/widgets/hardcoded_albums_row.dart';

import '../widgets/news_card.dart';

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
    return RefreshIndicator(
      onRefresh: () => Future<void>.value(null),
      backgroundColor: const Color(0xFF1A1B29),
      color: const Color(0xFF3FBCF4),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text(
                    'Welcome back,',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    ' $_nickname.',
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Here\'s what the world has been listening to.',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // TODO: Let user pick daily/weekly/monthly/yearly/all
              AlbumsRow(
                title: 'Popular Albums',
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
              HardcodedAlbumsRow(
                  title: "Hello, Grammys", albums: Constants.grammyList),
              const Text(
                'Explore the 2023 Grammy nominees for Album of the Year!',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              HardcodedAlbumsRow(
                  title: "Trill Team Favorites", albums: Constants.trillList),
              const Text(
                'Our team\'s top picks.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              const Text(
                'Recent News',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 20),
              NewsCard(
                title: Constants.newsList[0]['title']!,
                newsLink: Constants.newsList[0]['newsLink']!,
                imgLink: Constants.newsList[0]['imgLink']!,
                body: Constants.newsList[0]['body']!,
              ),
              NewsCard(
                title: Constants.newsList[1]['title']!,
                newsLink: Constants.newsList[1]['newsLink']!,
                imgLink: Constants.newsList[1]['imgLink']!,
                body: Constants.newsList[1]['body']!,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
