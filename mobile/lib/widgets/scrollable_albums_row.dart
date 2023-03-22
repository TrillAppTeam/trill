import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/pages/album_details.dart';

class ScrollableAlbumsRow extends StatelessWidget {
  ScrollableAlbumsRow({
    Key? key,
    this.title,
    required this.albums,
    this.emptyText,
  }) : super(key: key);

  String? title;
  final List<SpotifyAlbum> albums;
  String? emptyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null)
          Text(
            title!,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
              fontSize: 18,
              color: Color(0xFFcbd5e1),
            ),
          ),
        Divider(
          color: Colors.grey[700],
        ),
        albums.isEmpty
            ? Row(
                children: [
                  Text(
                    emptyText ?? '',
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              )
            : SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: albums.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AlbumDetailsScreen(
                              albumID: albums[index].id,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Image.network(
                          albums[index].images[0].url,
                          width: 75,
                        ),
                      ),
                    );
                  },
                ),
              ),
      ],
    );
  }
}
