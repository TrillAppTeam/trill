import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/scrollable_albums_row.dart';

import '../widgets/news_card.dart';

class HomeScreen extends StatefulWidget {
  final String nickname;

  const HomeScreen({super.key, required this.nickname});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late String _nickname;
  String _selectedRange = 'weekly';
  List<SpotifyAlbum>? _popularAlbums = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchPopularAlbums();
    _nickname = widget.nickname;
  }

  Future<void> _fetchPopularAlbums() async {
    setState(() {
      _isLoading = true;
      _popularAlbums = null;
    });

    final popularAlbums = await getMostPopularAlbums(_selectedRange);
    setState(() {
      _popularAlbums = popularAlbums;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : RefreshIndicator(
            onRefresh: _fetchPopularAlbums,
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
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        Text(
                          ' $_nickname.',
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 30,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Here\'s what the world has been listening to.',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
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
                            fontWeight: FontWeight.w900,
                            color: Color(0xFFcbd5e1),
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
                            fontWeight: FontWeight.w900,
                          ),
                          underline: Container(
                            height: 2,
                            color: const Color(0xFF3FBCF4),
                          ),
                          dropdownColor: const Color(0xFF1A1B29),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    _buildPopularAlbums(),
                    const SizedBox(height: 20),
                    ScrollableAlbumsRow(
                      title: "Hello, Grammys",
                      albums: Constants.grammyList,
                    ),
                    const Text(
                      'Explore the 2023 Grammy nominees for Album of the Year!',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF94a3b8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ScrollableAlbumsRow(
                        title: "Trill Team Favorites",
                        albums: Constants.trillList),
                    const Text(
                      'Our team\'s top picks.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Color(0xFF94a3b8),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Recent News',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                        color: Color(0xFFcbd5e1),
                      ),
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
            (_popularAlbums == null || _popularAlbums!.isEmpty)) {
          return _buildAlbumRowWithLoading();
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _popularAlbums = snapshot.data!;
          return ScrollableAlbumsRow(albums: _popularAlbums!);
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
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
    );
  }
}
