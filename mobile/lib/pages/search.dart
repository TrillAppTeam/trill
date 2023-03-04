import 'package:flutter/material.dart';
import '../api/albums.dart';
import '../models/album.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<SpotifyAlbum>? searchResults = [];

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
        child: Column(children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
                hintText: 'Enter search query', border: OutlineInputBorder()),
            autofocus: true,
            onSubmitted: (query) async {
              // Make API call and get results
              List<SpotifyAlbum>? response = await searchSpotifyAlbums(query);
              // Set results in state
              setState(() {
                searchResults = response;
              });
            },
          ),
          Expanded(
            child: ListView.builder(
              itemCount: searchResults?.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    // Navigate to album page
                  },
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    child: Row(
                      children: [
                        Image.network(searchResults![index].images[1].url,
                            width: 80, height: 80),
                        SizedBox(width: 16),
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(searchResults![index].name,
                                  style: TextStyle(fontSize: 16)),
                              SizedBox(height: 4),
                              Text(
                                  "${searchResults![index].artists.map((artist) => artist.name).join(", ")} - ${searchResults![index].releaseDate}",
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
        ]),
      ),
    );
  }
}
