import 'package:flutter/services.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trill/api/albums.dart';

import '../api/reviews.dart';

// todo: allow for updating - prefill fields if passed review
class WriteReviewScreen extends StatefulWidget {
  final SpotifyAlbum album;
  final Function onReviewAdded;

  const WriteReviewScreen(
      {super.key, required this.album, required this.onReviewAdded});

  @override
  _WriteReviewScreenState createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  int _rating = 10;
  final _reviewTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.delayed(
      const Duration(),
      () => SystemChannels.textInput.invokeMethod('TextInput.hide'),
    );
  }

  @override
  void dispose() {
    _reviewTextController.dispose();
    super.dispose();
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
        const SnackBar(content: Text('Failed to add review')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Write Your Review'),
          backgroundColor: Colors.transparent),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.album.name,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.album.artists[0].name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          DateFormat('MMMM yyyy')
                              .format(widget.album.releaseDate),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 50),
                        const Text(
                          'Your Rating',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(children: [
                          RatingBar.builder(
                            initialRating: 5,
                            minRating: 0.5,
                            direction: Axis.horizontal,
                            allowHalfRating: true,
                            itemCount: 5,
                            itemSize: 20,
                            itemPadding:
                                const EdgeInsets.symmetric(horizontal: 2.0),
                            itemBuilder: (context, _) => const Icon(
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
                      padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                      child: Image.network(
                        widget.album.images[0].url,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Your Review',
                  border: OutlineInputBorder(),
                ),
                autofocus: false,
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _publishReview,
                child: const Text('Publish'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
