import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/album_details.dart';
import '../api/albums.dart';
import '../models/album.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchType = 'albums';
  List<SpotifyAlbum>? _albumResults = [];
  List<User>? _userResults = [];

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // todo: remove back button
      appBar: AppBar(
        title: Text('Search'),
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Enter search query',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (query) async {
                      // Make API call and get results based on selected search type
                      if (_searchType == "albums") {
                        List<SpotifyAlbum>? response =
                            await searchSpotifyAlbums(query);
                        setState(() {
                          _albumResults = response;
                        });
                      }
                      // } else if (_searchType == "users") {
                      //   List<User>? response = await searchUsers(query);
                      //   setState(() {
                      //     _userResults = response;
                      //   });
                      // }
                    },
                  ),
                ),
                DropdownButton<String>(
                  value: _searchType,
                  onChanged: (String? value) {
                    setState(() {
                      _searchType = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: 'albums',
                      child: Text('Albums'),
                    ),
                    DropdownMenuItem(
                      value: 'users',
                      child: Text('Users'),
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _albumResults?.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AlbumDetailsScreen(
                              albumID: _albumResults![index].id),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.network(_albumResults![index].images[1].url,
                              width: 80, height: 80),
                          SizedBox(width: 16),
                          Flexible(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_albumResults![index].name,
                                    style: TextStyle(fontSize: 16)),
                                SizedBox(height: 4),
                                Text(
                                    "${_albumResults![index].artists.map((artist) => artist.name).join(", ")} - ${DateFormat('MMMM yyyy').format(_albumResults![index].releaseDate)}",
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
