import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:palette_generator/palette_generator.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/reviews.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/pages/write_review.dart';
import 'package:trill/widgets/album_details_header.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/review_tile.dart';
import 'package:trill/widgets/static_rating_bar.dart';

// todo: add review button
// todo: refresh upon review added

// todo: add to listenlater, add to favorite albums

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

class _AlbumDetailsScreenState extends State<AlbumDetailsScreen> {
  late SpotifyAlbum _album;
  List<Review>? _reviews;
  String _selectedSort = 'popular';

  bool _isLoading = true;

  late Future<PaletteGenerator> _paletteGenerator;
  final Color _appBarColor = const Color(0xFF1F1D36);

  final _scrollController = ScrollController();
  final bool _isCollapsed = false;

  @override
  void initState() {
    super.initState();
    _fetchAlbumDetails();
    // _paletteGenerator = _generatePalette();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _fetchAlbumDetails() async {
    setState(() {
      _isLoading = true;
      _reviews = null;
    });
    final album = await getSpotifyAlbum(widget.albumID);
    setState(() {
      _album = album!;
      _isLoading = false;
    });
  }

  Future<PaletteGenerator> _generatePalette() async {
    return await PaletteGenerator.fromImageProvider(
      const NetworkImage(
          'https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015'),
      size: Size(
        _album.images[0].width.toDouble(),
        _album.images[0].height.toDouble(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? const LoadingScreen()
        : RefreshIndicator(
            onRefresh: _fetchAlbumDetails,
            backgroundColor: const Color(0xFF1A1B29),
            color: const Color(0xFF3FBCF4),
            child: Scaffold(
              appBar: AppBar(),
              body: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: SafeArea(
                    child: Stack(
                      children: [
                        CustomScrollView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: _scrollController,
                          slivers: [
                            _buildBackdrop(context),
                            _buildAlbumDetails(),
                            _buildReviewDetails(),
                            _buildReviews(),
                          ],
                        ),
                        // temp button, does not scroll
                        Positioned(
                          bottom: 80.0,
                          right: 12.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white.withOpacity(.2),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.add,
                                color: Color(0xFF3FBCF4),
                              ),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => WriteReviewScreen(
                                      album: _album,
                                      onReviewAdded: _fetchAlbumDetails,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
  }

  Widget _buildBackdrop(BuildContext context) {
    return SliverPersistentHeader(
      pinned: true,
      floating: true,
      delegate: AlbumDetailsHeader(
        minHeight: 50.0,
        maxHeight: 200.0,
        album: _album,
      ),
    );
  }

  Widget _buildAlbumDetails() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildReviewDetails() {
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
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
          ],
        ),
      ),
    );
  }

  Widget _buildReviewList() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
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
              ),
            ],
          );
        },
        childCount: _reviews!.length,
      ),
    );
  }

  Widget _buildReviewListWithLoading() {
    return const SliverToBoxAdapter(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget _buildNoReviewsMessage() {
    return const SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            'No reviews yet',
            style: TextStyle(
              color: Color(0xFF3FBCF4),
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReviews() {
    return FutureBuilder<List<Review>?>(
      future: getAlbumReviews(_selectedSort, widget.albumID, false),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting &&
            (_reviews == null || _reviews!.isEmpty)) {
          return _buildReviewListWithLoading();
        }
        if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          _reviews = snapshot.data!;
          return _buildReviewList();
        }
        return _buildNoReviewsMessage();
      },
    );
  }
}
