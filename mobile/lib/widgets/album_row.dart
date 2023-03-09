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
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: Image.network(_album.images[0].url, width: 80, height: 80),
          ),
          const SizedBox(width: 16),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _album.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      _album.artists.map((artist) => artist.name).join(", "),
                      style: const TextStyle(
                        color: Color(0xFFCCCCCC),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      DateFormat('yyyy').format(_album.releaseDate),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
