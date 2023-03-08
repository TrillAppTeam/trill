import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/api/likes.dart';
import '../../api/reviews.dart';
import '../../api/users.dart';
import '../../widgets/detailed_review_tile.dart';
import '../../widgets/review_row.dart';
import '../../widgets/user_row.dart';
import '../profile.dart';

class LikedReviewsScreen extends StatefulWidget {
  const LikedReviewsScreen({super.key});

  @override
  State<LikedReviewsScreen> createState() => _LikedReviewsScreenState();
}

class _LikedReviewsScreenState extends State<LikedReviewsScreen> {
  List<TestLike>? _likeResults = [
    TestLike("prathik2001", 3924, "Dierks Bentley", "Dierks Bentley", 2004,
        "Blablabla", 5, 37),
    TestLike("prathik2001", 3924, "Dierks Bentley", "Dierks Bentley", 2004,
        "Blablabla", 5, 37),
    TestLike("prathik2001", 3924, "Dierks Bentley", "Dierks Bentley", 2004,
        "Blablabla", 5, 37)
  ];
  bool _isLoading = false;
  List<Review>? _reviews;

  @override
  void initState() {
    super.initState();
    _fetchUserDetails();
  }

  Future<void> _fetchUserDetails() async {
    setState(() {
      _isLoading = true;
    });

    //List<Like>? userResults = await getLikes();

    setState(() {
      _likeResults = _likeResults!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liked Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: _buildReviews()
      ),
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
                ? const SizedBox(height: 10)
                : const Divider(
              color: Colors.grey,
            ),
            DetailedReviewTile(
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
      itemCount: _reviews!.length,
      shrinkWrap: true,
    );
  }

  Widget _buildReviewListWithLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildNoReviewsMessage() {
    return const Padding(
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
    );
  }

  Widget _buildReviews() {
    return FutureBuilder<List<Review>?>(
      future: getReviews('popular'),
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
