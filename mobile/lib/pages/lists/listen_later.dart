import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/pages/loading_screen.dart';
import '../../widgets/album_row.dart';
import '../album_details.dart';

// todo: swipe or click edit button to delete listen later

class ListenLaterScreen extends StatefulWidget {
  const ListenLaterScreen({super.key});

  @override
  State<ListenLaterScreen> createState() => _ListenLaterScreenState();
}

class _ListenLaterScreenState extends State<ListenLaterScreen> {
  late List<SpotifyAlbum> _favoriteAlbums;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchListenLater();
  }

  Future<void> _fetchListenLater() async {
    setState(() {
      _isLoading = true;
    });

    final favoriteAlbums = await getFavoriteAlbums();

    if (favoriteAlbums != null) {
      setState(() {
        _favoriteAlbums = favoriteAlbums;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B29),
      appBar: AppBar(
        title: const Text('Listen Later'),
      ),
      body: _isLoading
          ? const LoadingScreen()
          : RefreshIndicator(
              onRefresh: _fetchListenLater,
              backgroundColor: const Color(0xFF1A1B29),
              color: const Color(0xFF3FBCF4),
              child: ListView.builder(
                itemCount: _favoriteAlbums.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetailsScreen(
                            albumID: _favoriteAlbums[index].id,
                          ),
                        ),
                      );
                    },
                    child: AlbumRow(album: _favoriteAlbums[index]),
                  );
                },
              ),
            ),
    );
  }
}
