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

// todo: add review button
// todo: refresh upon review added

// todo: add to listenlater, add to favorite albums

// todo: format album details
// todo: fix album details header

// todo: put own review at top and allow editing
// todo: create review only if user doesn't have review

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
                        Positioned(
                          top: 30.0,
                          left: 12.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.black.withOpacity(0.7),
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.white,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
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
              const Divider(
                color: Colors.grey,
              ),
              ListTile(
                leading: FutureBuilder(
                  // todo: get user's pfp
                  // future: getImageUrl(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return CircleAvatar(
                        // todo: change image to user's pfp, snapshot.data
                        backgroundImage: NetworkImage(
                          _album.images[0].url,
                        ),
                      );
                    } else {
                      // todo: change to actual placeholder
                      return CircleAvatar(
                        backgroundImage: NetworkImage(
                          _album.images[0].url,
                        ),
                      );
                    }
                  },
                ),
                title: RatingBar.builder(
                  initialRating: review.rating / 2,
                  minRating: 1,
                  allowHalfRating: true,
                  itemSize: 20,
                  itemBuilder: (context, _) => const Icon(
                    Icons.star,
                    color: Color(0xFFEEEEEE),
                  ),
                  onRatingUpdate: (rating) {},
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          review.username,
                          style: const TextStyle(
                            color: Color(0xFF3FBCF4),
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          timeago.format(
                            DateTime.now().subtract(
                              DateTime.now().difference(review.createdAt),
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          // ${timeago.format(DateTime.now().subtract(DateTime.now().difference(review.updatedAt)))}
                          review.updatedAt != review.createdAt
                              ? '(edited)'
                              : "",
                          style: const TextStyle(
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (review.reviewText.isNotEmpty)
                      Column(
                        children: [
                          ExpandableText(
                            text: review.reviewText,
                            maxLines: 5,
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    LikeButton(
                      reviewID: review.reviewID,
                      isLiked: review.isLiked,
                      numLikes: review.likes,
                      onLiked: (isLiked) {
                        setState(() {
                          review.isLiked = isLiked;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
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
