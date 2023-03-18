import 'package:flutter/material.dart';
import 'package:trill/pages/album_details.dart';

class HardcodedAlbumsRow extends StatefulWidget {
  final String title;
  final List<HardcodedAlbum> albums;
  String? emptyText;

  HardcodedAlbumsRow({
    Key? key,
    required this.title,
    required this.albums,
    this.emptyText,
  }) : super(key: key);

  @override
  State<HardcodedAlbumsRow> createState() => _HardcodedAlbumsRowState();
}

class _HardcodedAlbumsRowState extends State<HardcodedAlbumsRow> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
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
            : SizedBox(
                height: 100,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ...widget.albums.map((HardcodedAlbum album) {
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
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 16.0, 0),
                          child: Image.network(
                            album.image,
                            width: 78,
                          ),
                        ),
                      );
                    }),
                    const SizedBox(width: 8),
                  ],
                ),
              ),
      ],
    );
  }
}

class HardcodedAlbum {
  final String image;
  final String id;

  const HardcodedAlbum({
    required this.image,
    required this.id,
  });
}