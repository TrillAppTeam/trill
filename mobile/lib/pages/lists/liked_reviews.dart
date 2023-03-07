import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/api/likes.dart';
import '../../api/users.dart';
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
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : ListView.builder(
                  itemCount: _likeResults?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        SizedBox(height: 15),
                        ReviewRow(
                          title:
                          'Dierks Bentley',
                          artist: 'Dierks Bentley',
                          releaseYear: '2003',
                          reviewerName: 'Matthew',
                          starRating: 5,
                          reviewId: 69,
                          reviewText:
                          'What was I thinkin\'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resourcewith or without the use of tools to unlock a resource that has been secured with a password',
                          likeCount: 33,
                          imageUrl: 'images/DierksBentleyTest.jpg',
                        ),
                      ],
                    );
                }
          ),
        )
    );
  }
}

// USE THE REVIEW FORMAT FROM PROFILE PAGE FOR NOW
// FILL IN HARDCODED ADDL DATA
// MAKE SURE "LIKE" BUTTON IS FILLED IN - will be done in API call in ReviewRow
// IF REVIEW UNLIKED THEN REMOVE FROM PAGE
