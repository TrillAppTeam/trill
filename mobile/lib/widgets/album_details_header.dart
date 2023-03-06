import 'package:flutter/material.dart';
import 'package:trill/api/albums.dart';

class AlbumDetailsHeader extends SliverPersistentHeaderDelegate {
  final double minHeight;
  final double maxHeight;
  final SpotifyAlbum album;

  AlbumDetailsHeader({
    required this.minHeight,
    required this.maxHeight,
    required this.album,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress =
        (shrinkOffset / (maxHeight - minHeight)).clamp(0, 1);

    return Container(
      color: Colors.grey,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.grey.withOpacity(1.0 - progress),
              BlendMode.modulate,
            ),
            child: Image.network(
              album.images[0].url,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 10.0,
            left: 10.0,
            right: 10.0,
            child: Text(
              album.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(covariant AlbumDetailsHeader oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        album != oldDelegate.album;
  }
}
