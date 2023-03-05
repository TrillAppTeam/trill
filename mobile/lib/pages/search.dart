import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/widgets/album_row.dart';
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
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
          child: Column(
            children: [
              Text(
                'Search',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                        } else if (_searchType == "users") {
                          List<User>? response = await searchUsers(query);
                          setState(() {
                            _userResults = response;
                          });
                        }
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
                    icon: Icon(
                      Icons.arrow_drop_down,
                      color: Color(0xFF3FBCF4),
                    ),
                    iconSize: 24,
                    elevation: 16,
                    style: TextStyle(
                      color: Color(0xFF3FBCF4),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    underline: Container(
                      height: 2,
                      color: Color(0xFF3FBCF4),
                    ),
                    dropdownColor: Color(0xFF1A1B29),
                  ),
                ],
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _searchType == "albums"
                      ? _albumResults?.length ?? 0
                      : _userResults?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    if (_searchType == "albums") {
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
                    } else if (_searchType == "users") {
                      return InkWell(
                        onTap: () {
                          // todo: navigate to profile screen
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ProfileScreen(
                          //       userID: _userResults![index].id,
                          //     ),
                          //   ),
                          // );
                        },
                        child: Container(
                            // User list item widget
                            // ...
                            ),
                      );
                    } else {
                      // Return empty container if search type is not recognized
                      return Container();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
