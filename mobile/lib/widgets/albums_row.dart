import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/pages/album_details.dart';

class AlbumsRow extends StatefulWidget {
  final String title;
  final List<SpotifyAlbum> albums;
  String? emptyText;

  AlbumsRow({
    Key? key,
    required this.title,
    required this.albums,
    this.emptyText,
  }) : super(key: key);

  @override
  State<AlbumsRow> createState() => _AlbumsRowState();
}

class _AlbumsRowState extends State<AlbumsRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 15),
        widget.albums.isEmpty
            ? Row(
                children: [
                  Text(
                    widget.emptyText ?? '',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ...widget.albums.take(4).map((SpotifyAlbum album) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumDetailsScreen(
                              albumID: album.id,
                            ),
                          ),
                        );
                      },
                      child: Image.network(
                        album.images[0].url,
                        width: 75,
                      ),
                    );
                  }),
                  ...List.filled(
                    4 - widget.albums.length.clamp(0, 4),
                    Container(width: 75),
                  ),
                ],
              ),
      ],
    );
  }
}
