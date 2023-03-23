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
          Container(
            width: 85,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              border: Border.all(
                color: Color(0xFF6b7280)!,
                width: 2,
              ),
            ),
            child: ClipRRect(
              child: Image.network(
                _album.images[0].url,
                width: 80,
                height: 80,
              ),
            ),
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
                    fontWeight: FontWeight.w900,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const SizedBox(height: 4),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: _album.artists.map((artist) => artist.name).join(", "),
                        style: const TextStyle(
                          color: Color(0xFFCCCCCC),
                          fontSize: 16,
                          letterSpacing: .2,
                        ),
                      ),
                      TextSpan(
                        text: "  ${DateFormat('yyyy').format(_album.releaseDate)}",
                        style: const TextStyle(
                          color: Color(0xFF999999),
                          letterSpacing: .3,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
