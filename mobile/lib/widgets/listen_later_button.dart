import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';

import '../api/listen_later.dart';

class ListenLaterButton extends StatefulWidget {
  final String albumID;
  final bool isInListenLater;

  const ListenLaterButton({
    super.key,
    required this.albumID,
    required this.isInListenLater,
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
              ? const Color(0xFFAA2222)
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
