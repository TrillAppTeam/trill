import 'package:trill/api/albums.dart';

enum FollowType {
  following,
  follower,
}

class Constants {
  static const String baseURI = 'https://api.trytrill.com/main';
  static const List<Map<String, String>> newsList = [
    {
      'title': 'The 200 Greatest Singers of All Time',
      'body':
          'From Sinatra to SZA, from R&B to salsa to alt-rock. Explore the voices of the ages.',
      'newsLink':
          'https://www.rollingstone.com/music/music-lists/best-singers-all-time-1234642307/',
      'imgLink':
          'https://www.rollingstone.com/wp-content/uploads/2022/12/RollingStone_-200-Greatest-Singers_Collage.gif',
    },
    {
      'title':
          '2023 GRAMMY Nominations: See The Complete Winners & Nominees List',
      'body':
          'Read the complete list of winners and nominees across all 91 categories at the 2023 GRAMMYs here.',
      'newsLink':
          'https://www.grammy.com/news/2023-grammy-nominations-complete-winners-nominees-list',
      'imgLink':
          'https://i8.amplience.net/i/naras/2023-grammy-nominations-main-key-art.jpg?w=821&sm=c',
    },
  ];
  static List<SpotifyAlbum> grammyList = [
    SpotifyAlbum(
      name: 'Harry\'s House',
      id: '5r36AJ6VOJtp00oxSkBZ5h',
      releaseDate: DateTime(2022, 5, 20),
      artists: [
        const SpotifyArtist(name: 'Harry Styles'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Special',
      id: '1NgFBv1PxMG1zhFDW1OrRr',
      releaseDate: DateTime(2022, 7, 15),
      artists: [
        const SpotifyArtist(name: 'Lizzo'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273fe3b1b9cb7183a94e1aafd43',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Mr. Morale & The Big Steppers',
      id: '79ONNoS4M9tfIA1mYLBYVX',
      releaseDate: DateTime(2022, 5, 13),
      artists: [
        const SpotifyArtist(name: 'Kendrick Lamar'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2732e02117d76426a08ac7c174f',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Music Of The Spheres',
      id: '06mXfvDsRZNfnsGZvX2zpb',
      releaseDate: DateTime(2021, 10, 15),
      artists: [
        const SpotifyArtist(name: 'Coldplay'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273ec10f247b100da1ce0d80b6d',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'In These Silent Days',
      id: '5mIT7iw9w64DMP2vxP9L1f',
      releaseDate: DateTime(2021, 10, 1),
      artists: [
        const SpotifyArtist(name: 'Brandi Carlile'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b27335bd3c588974a8c239e5de87',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Good Morning Gorgeous (Deluxe)',
      id: '5K3aBzXwBvSltrtfBNYRl6',
      releaseDate: DateTime(2022, 5, 6),
      artists: [
        const SpotifyArtist(name: 'Mary J. Blige'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b27363b9d8845fe7d34795c16c9d',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'RENAISSANCE',
      id: '6FJxoadUE4JNVwWHghBwnb',
      releaseDate: DateTime(2022, 7, 29),
      artists: [
        const SpotifyArtist(name: 'Beyoncé'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Un Verano Sin Ti',
      id: '3RQQmkQEvNCY4prGKE6oc5',
      releaseDate: DateTime(2022, 5, 6),
      artists: [
        const SpotifyArtist(name: 'Bad Bunny'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b27349d694203245f241a1bcaa72',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: '30',
      id: '21jF5jlMtzo94wbxmJ18aa',
      releaseDate: DateTime(2021, 11, 19),
      artists: [
        const SpotifyArtist(name: 'Adele'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273c6b577e4c4a6d326354a89f7',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Voyage',
      id: '0uUtGVj0y9FjfKful7cABY',
      releaseDate: DateTime(2021, 11, 5),
      artists: [
        const SpotifyArtist(name: 'ABBA'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273225d9c1b06ca69aec9b08381',
          height: 640,
          width: 640,
        ),
      ],
    ),
  ];
  static List<SpotifyAlbum> trillList = [
    SpotifyAlbum(
      name: 'folklore (deluxe version)',
      id: '1pzvBxYgT6OVwJLtHkrdQK',
      releaseDate: DateTime(2020, 8, 18),
      artists: [
        const SpotifyArtist(name: 'Taylor Swift'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273c288028c2592f400dd0b9233',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Continuum',
      id: '1Xsprdt1q9rOzTic7b9zYM',
      releaseDate: DateTime(2006, 9, 11),
      artists: [
        const SpotifyArtist(name: 'John Mayer'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2737af5fdc5ef048a68db62b85f',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Ctrl',
      id: '76290XdXVF9rPzGdNRWdCh',
      releaseDate: DateTime(2017, 6, 9),
      artists: [
        const SpotifyArtist(name: 'SZA'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2734c79d5ec52a6d0302f3add25',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Siamese Dream (Deluxe Edition)',
      id: '0bQglEvsHphrS19FGODEGo',
      releaseDate: DateTime(1993, 1, 1),
      artists: [
        const SpotifyArtist(name: 'The Smashing Pumpkins'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2735274788f34fc7656d2856dfd',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'good kid, m.A.A.d city (Deluxe)',
      id: '3DGQ1iZ9XKUQxAUWjfC34w',
      releaseDate: DateTime(2012, 1, 1),
      artists: [
        const SpotifyArtist(name: 'Kendrick Lamar'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273d58e537cea05c2156792c53d',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Speak Now',
      id: '5MfAxS5zz8MlfROjGQVXhy',
      releaseDate: DateTime(2010, 10, 25),
      artists: [
        const SpotifyArtist(name: 'Taylor Swift'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Growin\' Up',
      id: '1m9DVgV0kEBiVZ4ElhJEte',
      releaseDate: DateTime(2022, 6, 24),
      artists: [
        const SpotifyArtist(name: 'Luke Combs'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b27387459a563f92e336d282ca59',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'From The Fires',
      id: '6uSnHSIBGKUiW1uKQLYZ7w',
      releaseDate: DateTime(2017, 11, 10),
      artists: [
        const SpotifyArtist(name: 'Greta Van Fleet'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b27357b7f789d328c205b4d15893',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'Punisher',
      id: '6Pp6qGEywDdofgFC1oFbSH',
      releaseDate: DateTime(2020, 6, 18),
      artists: [
        const SpotifyArtist(name: 'Phoebe Bridgers'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b273a91b75c9ef65ed8d760ff600',
          height: 640,
          width: 640,
        ),
      ],
    ),
    SpotifyAlbum(
      name: 'All Things Must Pass (2014 Remaster)',
      id: '4RzYS74QxvpqTDVwKbhuSg',
      releaseDate: DateTime(1970, 11, 20),
      artists: [
        const SpotifyArtist(name: 'George Harrison'),
      ],
      images: [
        const SpotifyImage(
          url:
              'https://i.scdn.co/image/ab67616d0000b2738a162cd60b075bef224ffab7',
          height: 640,
          width: 640,
        ),
      ],
    ),
  ];
}
