import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/follows.dart';
import '../../api/users.dart';
import '../../widgets/album_row.dart';
import '../../widgets/review_row.dart';
import '../../widgets/user_row.dart';
import '../album_details.dart';
import '../profile.dart';

class ListenLaterScreen extends StatefulWidget {
  const ListenLaterScreen({super.key});

  @override
  State<ListenLaterScreen> createState() => _ListenLaterScreenState();
}

class _ListenLaterScreenState extends State<ListenLaterScreen> {
  List<SpotifyAlbum>? _albumResults;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    List<SpotifyAlbum>? albumResults = await searchSpotifyAlbums("speak now");

    setState(() {
      _albumResults = albumResults!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Listen Later'),
        ),
        body: _isLoading
            ? const Center(child: CircularProgressIndicator())
            :  ListView.builder(
                  itemCount: _albumResults?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumDetailsScreen(
                              albumID: _albumResults![index].id,
                            ),
                          ),
                        );
                      },
                      child: AlbumRow(album: _albumResults![index]),
                    );
                  },
                ),
            );
  }
}

// use SEARCH album format
