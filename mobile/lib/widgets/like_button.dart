import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/likes.dart';

class LikeButton extends StatefulWidget {
  final int reviewID;
  final bool isLiked;
  final int numLikes;
  final void Function(bool) onLiked;

  const LikeButton({
    Key? key,
    required this.reviewID,
    required this.isLiked,
    required this.numLikes,
    required this.onLiked,
  }) : super(key: key);

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  int _numLikes = 0;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _numLikes = widget.numLikes;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          constraints: const BoxConstraints(),
          padding: EdgeInsets.zero,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_outline,
            color: _isLiked ? const Color(0xFF3FBCF4) : const Color(0xFFDDDDDD),
            size: 18,
          ),
          onPressed: () async {
            if (_isLiked) {
              final success = await unlikeReview(widget.reviewID);
              if (success) {
                setState(() {
                  _isLiked = false;
                  _numLikes -= 1;
                });
                widget.onLiked(false);
              } else {
                safePrint('Failed to unlike review ${widget.reviewID}');
              }
            } else {
              final success = await likeReview(widget.reviewID);
              if (success) {
                setState(() {
                  _isLiked = true;
                  _numLikes += 1;
                });
                widget.onLiked(true);
              } else {
                safePrint('Failed to unlike review ${widget.reviewID}');
              }
            }
          },
        ),
        const SizedBox(width: 8),
        Text(
          _numLikes.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }
}
