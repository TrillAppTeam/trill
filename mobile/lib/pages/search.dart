import 'package:flutter/material.dart';
import '../models/album.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Album> searchResults = [];

  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container (
            padding: EdgeInsets.all(8.0),
            child: Column (
              children: [ 
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(hintText: 'Enter search query',
                                              border: OutlineInputBorder()),
                  onSubmitted: (query) {
                  // Make API call and get results
                  List<Album> response = [Album(name: "Dierks Bentley", artistName: "Dierks Bentley", year: 2003),
                      Album(name: "Speak Now", artistName: "Taylor Swift", year: 2010)];
                  // Set results in state
                    setState(() {
                      searchResults = response;
                    }
                  );
                },
              ),
              SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            Image.asset("images/DierksBentleyTest.jpg", width: 80, height: 80),
                            SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(searchResults[index].name, style: TextStyle(fontSize: 18)),
                                SizedBox(height: 4),
                                Text("${searchResults[index].artistName} - ${searchResults[index].year}",
                                     style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ]
          ),
      ),
    );
  }
}
