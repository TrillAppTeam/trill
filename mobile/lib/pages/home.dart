import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/albums_row.dart';
import 'package:trill/widgets/hardcoded_albums_row.dart';

import '../widgets/news_card.dart';
import 'album_details.dart';

class HomeScreen extends StatefulWidget {
  final String nickname;

  const HomeScreen({super.key, required this.nickname});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _nickname;
  String _selectedRange = 'weekly';
  List<SpotifyAlbum> _albums = [];

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Popular Albums Globally',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<String>(
                    value: _selectedRange,
                    items: const [
                      DropdownMenuItem(
                        value: 'daily',
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: 'weekly',
                        child: Text('Weekly'),
                      ),
                      DropdownMenuItem(
                        value: 'monthly',
                        child: Text('Monthly'),
                      ),
                      DropdownMenuItem(
                        value: 'yearly',
                        child: Text('Yearly'),
                      ),
                      DropdownMenuItem(
                        value: 'all',
                        child: Text('All Time'),
                      ),
                    ],
                    onChanged: (String? value) {
                      setState(() {
                        _selectedRange = value!;
                        _buildPopularAlbums();
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF3FBCF4),
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: const TextStyle(
                      color: Color(0xFF3FBCF4),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 2,
                      color: const Color(0xFF3FBCF4),
                    ),
                    dropdownColor: const Color(0xFF1A1B29),
                  ),
                ],
              ),
              _buildPopularAlbums(),
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

  Widget _buildPopularAlbums() {
    return FutureBuilder<List<SpotifyAlbum>?>(
      future: getMostPopularAlbums(_selectedRange),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            (_albums == null || _albums!.isEmpty)) {
          return _buildAlbumRowWithLoading();
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _albums = snapshot.data!;
          return _buildAlbumRow();
        }
        return _buildNoReviewsMessage();
      },
    );
  }

  Widget _buildAlbumRowWithLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoReviewsMessage() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: Center(
        child: Text(
          'No activity in the selected time period.',
          style: TextStyle(
            color: Color(0xFF3FBCF4),
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildAlbumRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ..._albums.take(4).map((SpotifyAlbum album) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AlbumDetailsScreen(
                    albumID: album.id,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.network(
                album.images[0].url,
                width: 75,
              ),
            ),
          );
        }),
        ...List.filled(
          4 - _albums.length.clamp(0, 4),
          Container(width: 75),
        ),
      ],
    );
  }
}
