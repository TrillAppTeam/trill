import 'package:trill/widgets/hardcoded_albums_row.dart';

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
  static const List<HardcodedAlbum> grammyList = [
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2732e8ed79e177ff6011076f5f0",
        id: "5r36AJ6VOJtp00oxSkBZ5h"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273fe3b1b9cb7183a94e1aafd43",
        id: "1NgFBv1PxMG1zhFDW1OrRr"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2732e02117d76426a08ac7c174f",
        id: "79ONNoS4M9tfIA1mYLBYVX"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273ec10f247b100da1ce0d80b6d",
        id: "06mXfvDsRZNfnsGZvX2zpb"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b27335bd3c588974a8c239e5de87",
        id: "5mIT7iw9w64DMP2vxP9L1f"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b27363b9d8845fe7d34795c16c9d",
        id: "5K3aBzXwBvSltrtfBNYRl6"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2730e58a0f8308c1ad403d105e7",
        id: "6FJxoadUE4JNVwWHghBwnb"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b27349d694203245f241a1bcaa72",
        id: "3RQQmkQEvNCY4prGKE6oc5"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273c6b577e4c4a6d326354a89f7",
        id: "21jF5jlMtzo94wbxmJ18aa"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273225d9c1b06ca69aec9b08381",
        id: "0uUtGVj0y9FjfKful7cABY"),
  ];
  static const List<HardcodedAlbum> trillList = [
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273c288028c2592f400dd0b9233",
        id: "1pzvBxYgT6OVwJLtHkrdQK"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2737af5fdc5ef048a68db62b85f",
        id: "1Xsprdt1q9rOzTic7b9zYM"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2734c79d5ec52a6d0302f3add25",
        id: "76290XdXVF9rPzGdNRWdCh"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2735274788f34fc7656d2856dfd",
        id: "0bQglEvsHphrS19FGODEGo"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273d58e537cea05c2156792c53d",
        id: "3DGQ1iZ9XKUQxAUWjfC34w"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015",
        id: "5MfAxS5zz8MlfROjGQVXhy"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b27387459a563f92e336d282ca59",
        id: "1m9DVgV0kEBiVZ4ElhJEte"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b27357b7f789d328c205b4d15893",
        id: "6uSnHSIBGKUiW1uKQLYZ7w"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b273a91b75c9ef65ed8d760ff600",
        id: "6Pp6qGEywDdofgFC1oFbSH"),
    HardcodedAlbum(
        image:
            "https://i.scdn.co/image/ab67616d0000b2738a162cd60b075bef224ffab7",
        id: "4RzYS74QxvpqTDVwKbhuSg"),
  ];
}
