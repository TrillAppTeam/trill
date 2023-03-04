import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trill/api/favorite_albums.dart';

import '../api/reviews.dart';

class WriteReviewScreen extends StatefulWidget {
  final String albumID;

  WriteReviewScreen({required this.albumID});

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 0;
  String _review = "";
  bool _favorite = false;

  final _formKey = GlobalKey<FormState>();

  /*Future<void> _submitReview() async {

    if (response.statusCode == 200) {
      // Review submitted successfully
      Navigator.pop(context);
    } else {
      // Review submission failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to submit review'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Write Your Review'),
          backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
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
                          'Speak Now',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Taylor Swift',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '2010',
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
                            initialRating: 0,
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
                          IconButton(
                            icon: Icon(
                              _favorite
                                  ? Icons.favorite
                                  : Icons.favorite_outline,
                              color: Colors.red,
                            ),
                            onPressed: () {
                              setState(() {
                                _favorite = !_favorite;
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
                    child: Image.asset(
                      'images/DierksBentleyTest.jpg',
                    ),
                  )),
                ],
              ),
              /*Text(
                'Rate this album',
                style: Theme.of(context).textTheme.headline6,
              ),
              SizedBox(height: 10),
              RatingBar.builder(
                initialRating: 0,
                minRating: 0.5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = ((rating * 2).ceil().toInt());
                  });
                },
              ),*/
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                autofocus: true,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                validator: (value) {
                  if (value != null && value.isEmpty) {
                    return 'Please enter a review';
                  }
                  return null;
                },
                onChanged: (value) {
                  setState(() {
                    _review = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null) {
                    createOrUpdateReview(
                        "5MfAxS5zz8MlfROjGQVXhy", _rating, _review);
                    _favorite
                        ? addFavoriteAlbum("5MfAxS5zz8MlfROjGQVXhy")
                        : deleteFavoriteAlbum("5MfAxS5zz8MlfROjGQVXhy");
                  }
                },
                child: Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
