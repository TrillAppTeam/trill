import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/api/favorite_albums.dart';

import '../api/reviews.dart';

// todo: allow for updating - prefill fields if passed review
class WriteReviewScreen extends StatefulWidget {
  final SpotifyAlbum album;
  final Function onReviewAdded;

  WriteReviewScreen({required this.album, required this.onReviewAdded});

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 5;
  final _reviewTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void _publishReview() async {
    final reviewText = _reviewTextController.text;
    final success = await createOrUpdateReview(
      widget.album.id,
      _rating,
      reviewText,
    );

    if (success) {
      if (!mounted) return;
      Navigator.pop(context);
      widget.onReviewAdded();
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Write Your Review'),
          backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.album.name,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(
                        widget.album.artists[0].name,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        DateFormat('MMMM yyyy')
                            .format(widget.album.releaseDate),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 50),
                      Text(
                        'Your Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      Row(children: [
                        RatingBar.builder(
                          initialRating: 5,
                          minRating: 0.5,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 20,
                          itemPadding: EdgeInsets.symmetric(horizontal: 2.0),
                          itemBuilder: (context, _) => Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                          unratedColor: Colors.grey[850],
                          onRatingUpdate: (rating) {
                            setState(() {
                              _rating = ((rating * 2).ceil().toInt());
                            });
                          },
                        ),
                      ])
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                    child: Image.network(
                      widget.album.images[0].url,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              decoration: InputDecoration(
                labelText: 'Your Review',
                border: OutlineInputBorder(),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              validator: (value) {
                if (value != null && value.isEmpty) {
                  return 'Please enter a review';
                }
                return null;
              },
              controller: _reviewTextController,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _publishReview,
              child: Text('Publish'),
            ),
          ],
        ),
      ),
    );
  }
}
