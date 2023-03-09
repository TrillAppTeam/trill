import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/pages/write_review.dart';
import 'package:trill/widgets/review_tile.dart';

// todo: add review button
// todo: refresh upon review added

// todo: add to listenlater, add to favorite albums
// stretch: open in spotify

// todo: format album details
// todo: fix album details header

// todo: put own review at top and allow editing
// todo: create review only if user doesn't have review

// todo: update and delete own review

// todo: get user profile pic
// todo: click on username/pfp to get user profile

// todo: all, friends, self compound dropdown

// todo: review summary (total reviews, average review)
class AlbumDetailsScreen extends StatefulWidget {
  final String albumID;

  const AlbumDetailsScreen({super.key, required this.albumID});

  @override
  _AlbumDetailsScreenState createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen>
    with TickerProviderStateMixin {
  late SpotifyAlbum _album;
  List<Review>? _reviews;

  String _selectedSort = 'popular';
  bool _isLoading = true;

  late String _loggedInUser = "";

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _fetchAlbumDetails();
    _getLoggedInUser();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _fetchAlbumDetails() async {
    setState(() {
      _isLoading = true;
      _reviews = null;
    });

    final album = await getSpotifyAlbum(widget.albumID);
    if (album != null) {
      setState(() {
        _album = album;
        _isLoading = false;
      });
    }
  }

  void _getLoggedInUser() async {
    final prefs = await SharedPreferences.getInstance();
    _loggedInUser = prefs.getString('username') ?? "";
  }

  // Navigator.push(
  //   context,
  //   MaterialPageRoute(
  //     builder: (context) => WriteReviewScreen(
  //       album: _album,
  //       onReviewAdded: _fetchAlbumDetails,
  //     ),
  //   ),
  // );

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _fetchAlbumDetails,
      backgroundColor: const Color(0xFF1A1B29),
      color: const Color(0xFF3FBCF4),
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1B29),
        appBar: AppBar(),
        body: _isLoading
            ? const LoadingScreen()
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 12),
                    _buildAlbumDetails(),
                    _buildReviewDetails(),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.75,
                      child: _buildReviews(),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildAlbumDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _album.artists[0].name,
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          'Released: ${_album.releaseDate}',
          style: const TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          _album.label,
          style: const TextStyle(fontSize: 14.0),
        ),
      ],
    );
  }

  Widget _buildReviewDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Reviews',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            DropdownButton<String>(
              value: _selectedSort,
              items: const [
                DropdownMenuItem(
                  value: 'popular',
                  child: Text('Most liked'),
                ),
                DropdownMenuItem(
                  value: 'newest',
                  child: Text('Newest'),
                ),
                DropdownMenuItem(
                  value: 'oldest',
                  child: Text('Oldest'),
                ),
              ],
              onChanged: (String? value) {
                setState(() {
                  _selectedSort = value!;
                  _buildReviews();
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
                fontWeight: FontWeight.bold,
              ),
              underline: Container(
                height: 2,
                color: const Color(0xFF3FBCF4),
              ),
              dropdownColor: const Color(0xFF1A1B29),
            ),
          ],
        ),
        TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Global'),
            Tab(text: 'Following'),
            Tab(text: 'Me'),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewList() {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final review = _reviews![index];
        return Column(
          children: [
            index == 0
                ? Container()
                : const Divider(
                    color: Colors.grey,
                  ),
            ReviewTile(
              review: review,
              onLiked: (isLiked) {
                setState(() {
                  review.isLiked = isLiked;
                });
              },
              clickableUsername: _loggedInUser != review.username,
            ),
          ],
        );
      },
      itemCount: _reviews!.length,
    );
  }

  Widget _buildReviewListWithLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoReviewsMessage() {
    return const Align(
      alignment: Alignment.topCenter,
      child: Text(
        'No reviews yet',
        style: TextStyle(
          color: Color(0xFF3FBCF4),
          fontSize: 16.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return TabBarView(
      controller: _tabController,
      children: [
        FutureBuilder<List<Review>?>(
          // global
          future: getAlbumReviews(_selectedSort, widget.albumID, false),
          builder: (context, snapshot) {
            if (_tabController.index == 0 &&
                snapshot.connectionState == ConnectionState.waiting &&
                (_reviews == null || _reviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _reviews = snapshot.data!;
              return _buildReviewList();
            }
            return _buildNoReviewsMessage();
          },
        ),
        FutureBuilder<List<Review>?>(
          // following
          future: getAlbumReviews(_selectedSort, widget.albumID, true),
          builder: (context, snapshot) {
            if (_tabController.index == 1 &&
                snapshot.connectionState == ConnectionState.waiting &&
                (_reviews == null || _reviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _reviews = snapshot.data!;
              return _buildReviewList();
            }
            return _buildNoReviewsMessage();
          },
        ),
        FutureBuilder<Review?>(
          // me
          future: getReview(widget.albumID),
          builder: (context, snapshot) {
            if (_tabController.index == 2 &&
                snapshot.connectionState == ConnectionState.waiting &&
                (_reviews == null || _reviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData) {
              _reviews = [snapshot.data!];
              return _buildReviewList();
            }
            return _buildNoReviewsMessage();
          },
        ),
      ],
    );
  }
}
