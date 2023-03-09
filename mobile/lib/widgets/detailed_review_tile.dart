import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/pages/album_details.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/expandable_text.dart';
import 'package:trill/widgets/like_button.dart';
import 'package:trill/widgets/rating_bar.dart';

class DetailedReviewTile extends StatefulWidget {
  DetailedReviewTile({
    Key? key,
    required this.review,
    required this.onLiked,
    this.isMyReview = false,
    this.onUpdated,
  }) : super(key: key);

  final Review review;
  final void Function(bool) onLiked;

  bool isMyReview;
  final void Function(int, String)? onUpdated;

  @override
  State<DetailedReviewTile> createState() => _DetailedReviewTileState();
}

class _DetailedReviewTileState extends State<DetailedReviewTile> {
  bool _isEditing = false;
  int _editingRating = 0;

  TextEditingController? _reviewTextController;

  @override
  void initState() {
    super.initState();
    if (widget.isMyReview) {
      _reviewTextController =
          TextEditingController(text: widget.review.reviewText);
    }
  }

  @override
  void dispose() {
    if (_reviewTextController != null) {
      _reviewTextController!.dispose();
    }
    super.dispose();
  }

  void _startEditing() {
    setState(() {
      _isEditing = true;
      _editingRating = widget.review.rating;
    });
  }

  void _cancelEditing() {
    setState(() {
      _isEditing = false;
    });
  }

  void _saveEditing() {
    widget.onUpdated!(_editingRating, _reviewTextController!.text);
    setState(() {
      _isEditing = false;
    });
  }

  void _handleMenuClick(String value) {
    switch (value) {
      case 'edit':
        _startEditing();
        break;
      case 'report':
        safePrint('no');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: _buildAlbumImage(context),
      trailing: PopupMenuButton<String>(
        onSelected: (value) => _handleMenuClick(value),
        itemBuilder: (context) => [
          if (widget.isMyReview)
            const PopupMenuItem<String>(
              value: 'edit',
              child: Text(
                'Edit',
                style: TextStyle(
                  color: Color(0xFFCCCCCC),
                ),
              ),
            ),
          const PopupMenuItem<String>(
            value: 'report',
            child: Text(
              'Report',
              style: TextStyle(
                color: Color(0xFFAA2222),
              ),
            ),
          ),
        ],
        color: const Color(0xFF1A1B29),
        icon: const Icon(
          Icons.more_vert,
          color: Colors.grey,
        ),
      ),
      title: _buildTitle(),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 5),
          _buildAlbumDetails(context),
          const SizedBox(height: 5),
          _buildUserRow(context),
          const SizedBox(height: 8),
          _buildText(),
          _buildBottom(),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  InkWell _buildAlbumImage(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // todo: set album id
            builder: (context) => const AlbumDetailsScreen(
              albumID: '3xFXzriygSZ63hRXMHdZti',
            ),
          ),
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(3),
        child: Image.network(
          'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
          width: 60,
          height: 60,
        ),
      ),
    );
  }

  Widget _buildTitle() {
    if (_isEditing) {
      return ReviewRatingBar(
        rating: widget.review.rating,
        size: 20,
        isStatic: false,
        onRatingUpdate: (rating) {
          _editingRating = ((rating * 2).ceil().toInt());
        },
      );
    } else {
      return ReviewRatingBar(
        rating: widget.review.rating,
        size: 20,
      );
    }
  }

  InkWell _buildAlbumDetails(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AlbumDetailsScreen(
              albumID: widget.review.albumID,
            ),
          ),
        );
      },
      child: Row(
        children: const [
          Text(
            'Harry\'s House',
            style: TextStyle(
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(0xFFEEEEEE),
            ),
          ),
          Text(' - Harry Styles'),
        ],
      ),
    );
  }

  Row _buildUserRow(BuildContext context) {
    return Row(
      children: [
        _buildUserDetails(context),
        const SizedBox(width: 5),
        Text(
          timeago.format(
            DateTime.now().subtract(
              DateTime.now().difference(widget.review.createdAt),
            ),
          ),
        ),
        const SizedBox(width: 5),
        Text(
          // ${timeago.format(DateTime.now().subtract(DateTime.now().difference(review.updatedAt)))}
          widget.review.updatedAt != widget.review.createdAt ? '(edited)' : "",
          style: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  InkWell _buildUserDetails(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!widget.isMyReview) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                username: widget.review.username,
              ),
            ),
          );
        }
      },
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage(
              'https://media.tenor.com/z_hGCPQ_WvMAAAAd/pepew-twitch.gif',
            ),
            radius: 10,
          ),
          const SizedBox(width: 5),
          Text(
            widget.review.username,
            style: const TextStyle(
              color: Color(0xFF3FBCF4),
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildText() {
    if (_isEditing) {
      return Column(
        children: [
          const SizedBox(height: 5),
          TextFormField(
            controller: _reviewTextController,
            decoration: const InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
                borderSide: BorderSide(
                  color: Colors.grey,
                ),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 0,
              ),
            ),
            autofocus: false,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            style: const TextStyle(fontSize: 14),
          ),
          const SizedBox(height: 8),
        ],
      );
    } else if (widget.review.reviewText.isNotEmpty) {
      return Column(
        children: [
          ExpandableText(
            text: widget.review.reviewText,
            maxLines: 5,
          ),
          const SizedBox(height: 8),
        ],
      );
    } else {
      return Container();
    }
  }

  Widget _buildBottom() {
    if (_isEditing) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          ElevatedButton(
            onPressed: _cancelEditing,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey,
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            ),
            child: const Text('Cancel'),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: _saveEditing,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.fromLTRB(15, 5, 15, 5),
            ),
            child: const Text('Save'),
          ),
        ],
      );
    } else {
      return LikeButton(
        key: ValueKey('likeButton_${widget.review.reviewID}'),
        reviewID: widget.review.reviewID,
        isLiked: widget.review.isLiked,
        numLikes: widget.review.likes,
        onLiked: widget.onLiked,
      );
    }
  }
}
