import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:trill/api/albums.dart';

class AlbumRow extends StatelessWidget {
  const AlbumRow({
    Key? key,
    required SpotifyAlbum album,
  })  : _album = album,
        super(key: key);

  final SpotifyAlbum _album;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Row(
        children: [
          Image.network(_album.images[0].url, width: 80, height: 80),
          SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_album.name, style: TextStyle(fontSize: 16)),
                SizedBox(height: 4),
                Text(
                    "${_album.artists.map((artist) => artist.name).join(", ")} - ${DateFormat('MMMM yyyy').format(_album.releaseDate)}",
                    style: TextStyle(color: Colors.grey)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
