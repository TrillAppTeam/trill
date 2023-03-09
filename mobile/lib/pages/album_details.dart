import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/favorite_button.dart';
import 'package:trill/widgets/listen_later_button.dart';
import 'package:trill/widgets/review_tile.dart';
import 'package:trill/widgets/rating_bar.dart';

// todo: add review button
// todo: refresh upon review added

// todo: create review only if user doesn't have review
// todo: update and delete own review

class AlbumDetailsScreen extends StatefulWidget {
  final String albumID;

  const AlbumDetailsScreen({super.key, required this.albumID});

  @override
  _AlbumDetailsScreenState createState() => _AlbumDetailsScreenState();
}

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen>
    with TickerProviderStateMixin {
  late SpotifyAlbum _album;

  List<Review>? _globalReviews;
  late int _numReviews;

  List<Review>? _followingReviews;
  List<Review>? _myReviews;

  String _selectedSort = 'popular';
  bool _isLoading = true;

  bool _isFavorited = false;
  final bool _isInListenLater = false;

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
      _globalReviews = null;
      _followingReviews = null;
      _myReviews = null;
    });

    final globalReviews =
        await getAlbumReviews(_selectedSort, widget.albumID, false);

    // these should really be done through the apis tbh
    setState(() {
      _numReviews = globalReviews == null ? 0 : globalReviews.length;
    });

    final favoriteAlbums = await getFavoriteAlbums() ?? [];

    for (int i = 0; i < favoriteAlbums.length; i++) {
      if (favoriteAlbums[i].id == widget.albumID) {
        setState(() {
          _isFavorited = true;
        });
      }
    }

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
                    const SizedBox(height: 5),
                    _buildAlbumButtons(),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(3),
              child: Image.network(
                _album.images[0].url,
                width: 120,
                height: 120,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _album.name,
                  style: const TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  children: [
                    Text(
                      _album.artists.map((artist) => artist.name).join(", "),
                      style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('yyyy').format(_album.releaseDate),
                      style: const TextStyle(
                        color: Color(0xFF999999),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    // todo: get average rating
                    const ReviewRatingBar(rating: 7, size: 20),
                    const SizedBox(width: 5),
                    Text(
                      '(${_numReviews.toString()})',
                      style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbumButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FavoriteButton(
          albumID: widget.albumID,
          isFavorited: _isFavorited,
          onError: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Color(0xFFAA2222),
                content: Text(
                  "Maximum favorite albums count of 4 reached. Remove an album from your profile to add more!",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            );
          },
        ),
        ListenLaterButton(
          albumID: widget.albumID,
          isInListenLater: _isInListenLater,
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

  Widget _buildReviewList(List<Review> reviews) {
    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        final review = reviews[index];
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
              isMyReview: _loggedInUser == review.username,
              onUpdated: _loggedInUser == review.username
                  ? (rating, reviewText) async {
                      final success = await createOrUpdateReview(
                          widget.albumID, rating, reviewText);
                      if (success) {
                        setState(() {
                          review.rating = rating;
                          review.reviewText = reviewText;
                        });
                      }
                    }
                  : (rating, reviewText) {},
            ),
          ],
        );
      },
      itemCount: reviews.length,
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
                (_globalReviews == null || _globalReviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _globalReviews = snapshot.data!;
              return _buildReviewList(_globalReviews!);
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
                (_followingReviews == null || _followingReviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              _followingReviews = snapshot.data!;
              return _buildReviewList(_followingReviews!);
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
                (_myReviews == null || _myReviews!.isEmpty)) {
              return _buildReviewListWithLoading();
            }
            if (snapshot.hasData) {
              _myReviews = [snapshot.data!];
              return _buildReviewList(_myReviews!);
            }
            return Container();
          },
        ),
      ],
    );
  }
}
