import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ReviewRow extends StatefulWidget {
  final String title;
  final String artist;
  final int starRating;
  final String reviewerName;
  final int reviewId;
  final String releaseYear;
  final String reviewText;
  int likeCount;
  final String imageUrl;

  ReviewRow({
    Key? key,
    required this.title,
    required this.artist,
    required this.starRating,
    required this.reviewerName,
    required this.reviewId,
    required this.releaseYear,
    required this.reviewText,
    required this.likeCount,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _ReviewRowState createState() => _ReviewRowState();
}

class _ReviewRowState extends State<ReviewRow> {
  bool _isLiked = false;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      if (_isLiked == false)
        widget.likeCount--;
      else
        widget.likeCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
      color: const Color(0xFF392B3A),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "${widget.artist} - ${widget.releaseYear}",
                  style: const TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    const Text(
                      "Reviewed by ",
                      style: TextStyle(
                        fontSize: 11,
                      ),
                    ),
                    Text(
                      widget.reviewerName,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Row(
                      children: List.generate(
                        widget.starRating ~/ 2,
                        (index) => Icon(
                          Icons.star,
                          color: Colors.yellow,
                          size: 16,
                        ),
                      ).toList(),
                    ),
                    if (widget.starRating % 2 != 0)
                      Icon(
                        Icons.star_half,
                        color: Colors.yellow,
                        size: 16,
                      ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  widget.reviewText,
                  style: const TextStyle(fontSize: 12),
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    GestureDetector(
                      onTap: _toggleLike,
                      child: Icon(
                          _isLiked
                              ? Icons.favorite
                              : Icons.favorite_border_outlined,
                          size: 20,
                          color: Colors.red),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      "${widget.likeCount} likes",
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
            child: Image.asset(
              widget.imageUrl,
              width: 120,
              height: 120,
            ),
          ),
        ],
      ),
    );
  }
}
