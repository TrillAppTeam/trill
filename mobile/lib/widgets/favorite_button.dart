import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/favorite_albums.dart';

class FavoriteButton extends StatefulWidget {
  final String albumID;
  final bool isFavorited;
  final Function onError;

  const FavoriteButton({
    super.key,
    required this.albumID,
    required this.isFavorited,
    required this.onError,
  });

  @override
  _FavoriteButtonState createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  late bool _isFavorited;

  @override
  void initState() {
    super.initState();
    _isFavorited = widget.isFavorited;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (_isFavorited) {
          final success = await unfavoriteAlbum(widget.albumID);
          if (success) {
            setState(() {
              _isFavorited = false;
            });
          } else {
            safePrint('Failed to unfavorite album ${widget.albumID}');
          }
        } else {
          final success = await favoriteAlbum(widget.albumID);
          if (success) {
            setState(() {
              _isFavorited = true;
            });
          } else {
            safePrint('Failed to favorite album ${widget.albumID}');
            widget.onError();
          }
        }
      },
      child: Container(
        width: 180,
        height: 30,
        decoration: BoxDecoration(
          color:
              _isFavorited ? const Color(0xFFAA2222) : const Color(0xFF383B59),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              _isFavorited ? 'REMOVE FROM FAVORITES' : 'ADD TO FAVORITES',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
