import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';
import 'package:trill/api/likes.dart';
import '../../api/users.dart';
import '../../widgets/user_row.dart';
import '../profile.dart';

class LikedAlbumsScreen extends StatefulWidget {
  const LikedAlbumsScreen({super.key});

  @override
  State<LikedAlbumsScreen> createState() => _LikedAlbumsScreenState();
}

class _LikedAlbumsScreenState extends State<LikedAlbumsScreen> {
  List<TestLike>? _likeResults = [TestLike("prathik2001", 3924, "Dierks Bentley", "Dierks Bentley", 2004, "Blablabla", 5, 37)];
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
          title: const Text('Liked Albums'),
        ),
        body: _isLoading ? const Center(child: CircularProgressIndicator()) :
        ListView.builder(
            itemCount: _likeResults?.length,
            itemBuilder: (BuildContext context, int index) {
              return  Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _likeResults![index].albumName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${_likeResults![index].artistName} - ${_likeResults![index].year}",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Text(
                          "Reviewed by ",
                          style: TextStyle(
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          "${_likeResults![index].username} ",
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                          ),
                        ),
                        Row(
                          children: List.generate(
                            _likeResults![index].starRating ~/ 2,
                                (index) => Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 10,
                            ),
                          ).toList(),
                        ),
                        if (_likeResults![index].starRating % 2 != 0)
                          Icon(
                            Icons.star_half,
                            color: Colors.white,
                            size: 10,
                          ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _likeResults![index].reviewBody,
                      style: TextStyle(fontSize: 12),
                      maxLines: 5,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Icon(
                          Icons.favorite_outline_outlined,
                          size: 20,
                        ),
                        SizedBox(width: 10),
                        Text(
                          "${_likeResults![index].likeCount} likes",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            }
        )
    );
  }
}

// USE THE REVIEW FORMAT FROM PROFILE PAGE FOR NOW
// FILL IN HARDCODED ADDL DATA
// MAKE SURE "LIKE" BUTTON IS FILLED IN
// IF REVIEW UNLIKED THEN REMOVE FROM PAGE
