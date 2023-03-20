import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/pages/loading_screen.dart';
import '../../api/listen_later.dart';
import '../../widgets/album_row.dart';
import '../album_details.dart';

// TODO: swipe or click edit button to delete listen later

class ListenLaterScreen extends StatefulWidget {
  const ListenLaterScreen({super.key});

  @override
  State<ListenLaterScreen> createState() => _ListenLaterScreenState();
}

class _ListenLaterScreenState extends State<ListenLaterScreen> {
  late List<SpotifyAlbum> _listenLaterAlbums = [];
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

    final listenLaterAlbums = await getListenLaterAlbums();

    if (listenLaterAlbums != null) {
      setState(() {
        _listenLaterAlbums = listenLaterAlbums;
      });
    }

    setState(() {
      _isLoading = false;
    });
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
          : _listenLaterAlbums.isEmpty
              ? Row(
                  children: const [
                    Expanded(
                      child: Center(
                        child: Text(
                          'No listen later albums. Add some albums to listen later to see them here!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontStyle: FontStyle.italic, fontSize: 36),
                        ),
                      ),
                    ),
                  ],
                )
              : RefreshIndicator(
                  onRefresh: _fetchListenLater,
                  backgroundColor: const Color(0xFF1A1B29),
                  color: const Color(0xFF3FBCF4),
                  child: ListView.builder(
                    itemCount: _listenLaterAlbums.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AlbumDetailsScreen(
                                albumID: _listenLaterAlbums[index].id,
                              ),
                            ),
                          );
                        },
                        child: AlbumRow(album: _listenLaterAlbums[index]),
                      );
                    },
                  ),
                ),
    );
  }
}
