import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../api/listen_later.dart';

class ListenLaterButton extends StatefulWidget {
  final String albumID;
  final bool isInListenLater;
  final bool isReviewed;

  const ListenLaterButton({
    super.key,
    required this.albumID,
    required this.isInListenLater,
    required this.isReviewed,
  });

  @override
  _ListenLaterButtonState createState() => _ListenLaterButtonState();
}

class _ListenLaterButtonState extends State<ListenLaterButton> {
  late bool _isInListenLater;

  @override
  void initState() {
    super.initState();
    _isInListenLater = widget.isInListenLater;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isReviewed) {
      return Container(
        width: 180,
        height: 30,
        decoration: BoxDecoration(
          color: const Color(0xFF585B79),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              'ALREADY REVIEWED',
              style: TextStyle(
                color: Colors.grey[400],
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ),
      );
    }
    return InkWell(
      onTap: () async {
        if (_isInListenLater) {
          final success = await deleteListenLater(widget.albumID);
          if (success) {
            setState(() {
              _isInListenLater = false;
            });
          } else {
            safePrint(
                'Failed to remove album ${widget.albumID} from listen later');
          }
        } else {
          final success = await addListenLater(widget.albumID);
          if (success) {
            setState(() {
              _isInListenLater = true;
            });
          } else {
            safePrint('Failed to add album ${widget.albumID} to listen later');
          }
        }
      },
      child: Container(
        width: 180,
        height: 30,
        decoration: BoxDecoration(
          color: _isInListenLater
              ? const Color(0xFF3FBCF4)
              : const Color(0xFF383B59),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Center(
            child: Text(
              _isInListenLater
                  ? 'REMOVE FROM LISTEN LATER'
                  : 'ADD TO LISTEN LATER',
              style: TextStyle(
                color: _isInListenLater ? Colors.black : Colors.grey[200],
                fontWeight: FontWeight.bold,
                fontSize: _isInListenLater ? 11.5 : 12,
                letterSpacing: .2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
