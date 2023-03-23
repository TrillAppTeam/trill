import 'dart:async';

import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/album_row.dart';
import 'package:trill/widgets/user_row.dart';
import '../api/albums.dart';

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
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  bool _isLoading = false;
  Timer? _searchTimer;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchResults() async {
    setState(() {
      _isLoading = true;
    });

    if (_searchType == "albums") {
      List<SpotifyAlbum>? response =
          await searchSpotifyAlbums(_searchController.text);
      setState(() {
        _albumResults = response;
        _isLoading = false;
      });
    } else if (_searchType == "users") {
      List<User>? response = await searchUsers(_searchController.text);
      setState(() {
        _userResults = response;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        final FocusScopeNode currentScope = FocusScope.of(context);
        if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Color(0xFF3FBCF4),
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10),
                              ),
                              borderSide: BorderSide(
                                color: Colors.grey[800]!,
                              ),
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 12,
                            ),
                          ),
                          onChanged: (query) {
                            _searchTimer?.cancel();
                            _searchTimer = Timer(
                                const Duration(milliseconds: 500),
                                _fetchResults);
                          },
                          onEditingComplete: () {
                            final FocusScopeNode currentScope =
                                FocusScope.of(context);
                            if (!currentScope.hasPrimaryFocus &&
                                currentScope.hasFocus) {
                              FocusManager.instance.primaryFocus?.unfocus();
                            }
                            _fetchResults();
                          },
                          autofocus: false,
                          style: TextStyle(
                            color: Colors.grey[200],
                            fontSize: 16,
                            letterSpacing: .2,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      DropdownButton<String>(
                        value: _searchType,
                        onChanged: (String? value) {
                          setState(() {
                            _searchType = value!;
                            _albumResults = null;
                            _userResults = null;
                            _searchController.clear();
                          });
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'albums',
                            child: Text('Albums'),
                          ),
                          DropdownMenuItem(
                            value: 'users',
                            child: Text('Users'),
                          ),
                        ],
                        icon: const Icon(
                          Icons.arrow_drop_down,
                          color: Color(0xFF3FBCF4),
                        ),
                        iconSize: 24,
                        elevation: 3,
                        style: const TextStyle(
                          color: Color(0xFF3FBCF4),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                        underline: Container(
                          height: 2,
                          color: const Color(0xFF3FBCF4),
                        ),
                        dropdownColor: const Color(0xFF222331),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: _fetchResults,
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
                                        builder: (context) =>
                                            AlbumDetailsScreen(
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
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ProfileScreen(
                                          username:
                                              _userResults![index].username,
                                        ),
                                      ),
                                    );
                                  },
                                  child: UserRow(user: _userResults![index]),
                                );
                              } else {
                                // Return empty container if search type is not recognized
                                return Container();
                              }
                            },
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
