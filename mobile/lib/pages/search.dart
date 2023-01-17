import 'package:flutter/material.dart';
import '../widgets/bottomnav.dart';

class SearchResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Result 1'),
                ),
                ListTile(
                  title: Text('Result 2'),
                ),
                ListTile(
                  title: Text('Result 3'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                  hintText: 'Enter search query', border: OutlineInputBorder()),
              onSubmitted: (query) {
                Navigator.pushNamed(context, '/searchResults');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}
