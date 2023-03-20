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
  static const String speakNowAlbums =
      '''[{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/5MfAxS5zz8MlfROjGQVXhy"},"href":"https://api.spotify.com/v1/albums/5MfAxS5zz8MlfROjGQVXhy","id":"5MfAxS5zz8MlfROjGQVXhy","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273e11a75a2f2ff39cec788a015","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02e11a75a2f2ff39cec788a015","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851e11a75a2f2ff39cec788a015","height":64,"width":64}],"name":"Speak Now","release_date":"2010-10-25","type":"album","uri":"spotify:album:5MfAxS5zz8MlfROjGQVXhy","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/5EpMjweRD573ASl7uNiHym"},"href":"https://api.spotify.com/v1/albums/5EpMjweRD573ASl7uNiHym","id":"5EpMjweRD573ASl7uNiHym","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2732e4ec3175d848eca7b76b07f","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e022e4ec3175d848eca7b76b07f","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048512e4ec3175d848eca7b76b07f","height":64,"width":64}],"name":"Speak Now (Deluxe Edition)","release_date":"2010-10-25","type":"album","uri":"spotify:album:5EpMjweRD573ASl7uNiHym","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/6fyR4wBPwLHKcRtxgd4sGh"},"href":"https://api.spotify.com/v1/albums/6fyR4wBPwLHKcRtxgd4sGh","id":"6fyR4wBPwLHKcRtxgd4sGh","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273be4ec62353ee75fa11f6d6f7","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02be4ec62353ee75fa11f6d6f7","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851be4ec62353ee75fa11f6d6f7","height":64,"width":64}],"name":"Speak Now World Tour Live","release_date":"2010-10-25","type":"album","uri":"spotify:album:6fyR4wBPwLHKcRtxgd4sGh","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/4hDok0OAJd57SGIT8xuWJH"},"href":"https://api.spotify.com/v1/albums/4hDok0OAJd57SGIT8xuWJH","id":"4hDok0OAJd57SGIT8xuWJH","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273a48964b5d9a3d6968ae3e0de","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02a48964b5d9a3d6968ae3e0de","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851a48964b5d9a3d6968ae3e0de","height":64,"width":64}],"name":"Fearless (Taylor's Version)","release_date":"2021-04-09","type":"album","uri":"spotify:album:4hDok0OAJd57SGIT8xuWJH","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/75N0Z60SNMQbAPYZuxKgWd"},"href":"https://api.spotify.com/v1/albums/75N0Z60SNMQbAPYZuxKgWd","id":"75N0Z60SNMQbAPYZuxKgWd","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2730ac2865a6b8b6ffecf85ce7d","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e020ac2865a6b8b6ffecf85ce7d","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048510ac2865a6b8b6ffecf85ce7d","height":64,"width":64}],"name":"Speak Now (Big Machine Radio Release Special)","release_date":"2010-10-25","type":"album","uri":"spotify:album:75N0Z60SNMQbAPYZuxKgWd","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"single","external_urls":{"spotify":"https://open.spotify.com/album/7lj05DmCzCTu4Hxvnk1jAR"},"href":"https://api.spotify.com/v1/albums/7lj05DmCzCTu4Hxvnk1jAR","id":"7lj05DmCzCTu4Hxvnk1jAR","images":[{"url":"https://i.scdn.co/image/ab67616d0000b27303444691e9ecb39a0493c7c0","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e0203444691e9ecb39a0493c7c0","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d0000485103444691e9ecb39a0493c7c0","height":64,"width":64}],"name":"Speak Now (From The Motion Picture Soundtrack Of One Night In Miami...)","release_date":"2021-01-05","type":"album","uri":"spotify:album:7lj05DmCzCTu4Hxvnk1jAR","genres":null,"label":"","popularity":0,"artists":[{"id":"3cR4rhS2hBWqI7rJEBacvN","name":"Leslie Odom Jr.","type":"artist","uri":"spotify:artist:3cR4rhS2hBWqI7rJEBacvN"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/6kZ42qRrzov54LcAk4onW9"},"href":"https://api.spotify.com/v1/albums/6kZ42qRrzov54LcAk4onW9","id":"6kZ42qRrzov54LcAk4onW9","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273318443aab3531a0558e79a4d","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02318443aab3531a0558e79a4d","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851318443aab3531a0558e79a4d","height":64,"width":64}],"name":"Red (Taylor's Version)","release_date":"2021-11-12","type":"album","uri":"spotify:album:6kZ42qRrzov54LcAk4onW9","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/64kePIptanLPIdN8gLrUpC"},"href":"https://api.spotify.com/v1/albums/64kePIptanLPIdN8gLrUpC","id":"64kePIptanLPIdN8gLrUpC","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2732ab6bf343789147492f02ae2","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e022ab6bf343789147492f02ae2","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048512ab6bf343789147492f02ae2","height":64,"width":64}],"name":"Speak Now (Piano Instrumental)","release_date":"2023-02-02","type":"album","uri":"spotify:album:64kePIptanLPIdN8gLrUpC","genres":null,"label":"","popularity":0,"artists":[{"id":"79Yty2ANzT9cb4iZvz6LxG","name":"Peaceful Noise","type":"artist","uri":"spotify:artist:79Yty2ANzT9cb4iZvz6LxG"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/34OkZVpuzBa9y40DCy0LPR"},"href":"https://api.spotify.com/v1/albums/34OkZVpuzBa9y40DCy0LPR","id":"34OkZVpuzBa9y40DCy0LPR","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273332d85510aba3eb28312cfb2","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02332d85510aba3eb28312cfb2","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851332d85510aba3eb28312cfb2","height":64,"width":64}],"name":"1989 (Deluxe Edition)","release_date":"2014-10-27","type":"album","uri":"spotify:album:34OkZVpuzBa9y40DCy0LPR","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"single","external_urls":{"spotify":"https://open.spotify.com/album/1ThLwxgGP863wOZzpaD5xw"},"href":"https://api.spotify.com/v1/albums/1ThLwxgGP863wOZzpaD5xw","id":"1ThLwxgGP863wOZzpaD5xw","images":[{"url":"https://i.scdn.co/image/ab67616d0000b27354e9b234b7d6cb060c57db54","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e0254e9b234b7d6cb060c57db54","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d0000485154e9b234b7d6cb060c57db54","height":64,"width":64}],"name":"Speak Now (Selections From One Night In Miami... Soundtrack)","release_date":"2021-04-09","type":"album","uri":"spotify:album:1ThLwxgGP863wOZzpaD5xw","genres":null,"label":"","popularity":0,"artists":[{"id":"3cR4rhS2hBWqI7rJEBacvN","name":"Leslie Odom Jr.","type":"artist","uri":"spotify:artist:3cR4rhS2hBWqI7rJEBacvN"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/6DEjYFkNZh67HP7R9PSZvv"},"href":"https://api.spotify.com/v1/albums/6DEjYFkNZh67HP7R9PSZvv","id":"6DEjYFkNZh67HP7R9PSZvv","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273da5d5aeeabacacc1263c0f4b","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02da5d5aeeabacacc1263c0f4b","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851da5d5aeeabacacc1263c0f4b","height":64,"width":64}],"name":"reputation","release_date":"2017-11-10","type":"album","uri":"spotify:album:6DEjYFkNZh67HP7R9PSZvv","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/3vvbc7aLOQvKoSTvGgbPq0"},"href":"https://api.spotify.com/v1/albums/3vvbc7aLOQvKoSTvGgbPq0","id":"3vvbc7aLOQvKoSTvGgbPq0","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2730c34a154244cff165aae852a","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e020c34a154244cff165aae852a","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048510c34a154244cff165aae852a","height":64,"width":64}],"name":"Speak Now or Forever Hold Your Pain","release_date":"2013-05-31","type":"album","uri":"spotify:album:3vvbc7aLOQvKoSTvGgbPq0","genres":null,"label":"","popularity":0,"artists":[{"id":"7z1VrrLktQYoS9C0cFbfnI","name":"Tatiana Manaois","type":"artist","uri":"spotify:artist:7z1VrrLktQYoS9C0cFbfnI"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/7mzrIsaAjnXihW3InKjlC3"},"href":"https://api.spotify.com/v1/albums/7mzrIsaAjnXihW3InKjlC3","id":"7mzrIsaAjnXihW3InKjlC3","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2732f8c0fd72a80a93f8c53b96c","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e022f8c0fd72a80a93f8c53b96c","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048512f8c0fd72a80a93f8c53b96c","height":64,"width":64}],"name":"Taylor Swift","release_date":"2006-10-24","type":"album","uri":"spotify:album:7mzrIsaAjnXihW3InKjlC3","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/2QJmrSgbdM35R67eoGQo4j"},"href":"https://api.spotify.com/v1/albums/2QJmrSgbdM35R67eoGQo4j","id":"2QJmrSgbdM35R67eoGQo4j","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2739abdf14e6058bd3903686148","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e029abdf14e6058bd3903686148","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048519abdf14e6058bd3903686148","height":64,"width":64}],"name":"1989","release_date":"2014-10-27","type":"album","uri":"spotify:album:2QJmrSgbdM35R67eoGQo4j","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"single","external_urls":{"spotify":"https://open.spotify.com/album/1Tk6HI5p20JxSCmVvU7MvD"},"href":"https://api.spotify.com/v1/albums/1Tk6HI5p20JxSCmVvU7MvD","id":"1Tk6HI5p20JxSCmVvU7MvD","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273cc0de03bc397d38885faf3ac","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02cc0de03bc397d38885faf3ac","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851cc0de03bc397d38885faf3ac","height":64,"width":64}],"name":"Speak Now (Samuel's Prayer) [Live]","release_date":"2023-02-24","type":"album","uri":"spotify:album:1Tk6HI5p20JxSCmVvU7MvD","genres":null,"label":"","popularity":0,"artists":[{"id":"5O8cAm8uIkCn0hOPDDpZl0","name":"Sound of the House","type":"artist","uri":"spotify:artist:5O8cAm8uIkCn0hOPDDpZl0"},{"id":"4oLDDlPUpiKowrWoJLS94r","name":"Austin & Lindsey Adamec","type":"artist","uri":"spotify:artist:4oLDDlPUpiKowrWoJLS94r"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/1NAmidJlEaVgA3MpcPFYGq"},"href":"https://api.spotify.com/v1/albums/1NAmidJlEaVgA3MpcPFYGq","id":"1NAmidJlEaVgA3MpcPFYGq","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273e787cffec20aa2a396a61647","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02e787cffec20aa2a396a61647","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851e787cffec20aa2a396a61647","height":64,"width":64}],"name":"Lover","release_date":"2019-08-23","type":"album","uri":"spotify:album:1NAmidJlEaVgA3MpcPFYGq","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/2dqn5yOQWdyGwOpOIi9O4x"},"href":"https://api.spotify.com/v1/albums/2dqn5yOQWdyGwOpOIi9O4x","id":"2dqn5yOQWdyGwOpOIi9O4x","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2737b25c072237f29ee50025fdc","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e027b25c072237f29ee50025fdc","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048517b25c072237f29ee50025fdc","height":64,"width":64}],"name":"Fearless","release_date":"2008-11-11","type":"album","uri":"spotify:album:2dqn5yOQWdyGwOpOIi9O4x","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"single","external_urls":{"spotify":"https://open.spotify.com/album/6ZWvztYmhLnTowiP1nlq6k"},"href":"https://api.spotify.com/v1/albums/6ZWvztYmhLnTowiP1nlq6k","id":"6ZWvztYmhLnTowiP1nlq6k","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2738f39dbb40cd5ee434d9fb2b3","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e028f39dbb40cd5ee434d9fb2b3","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048518f39dbb40cd5ee434d9fb2b3","height":64,"width":64}],"name":"Speak Now","release_date":"2023-01-13","type":"album","uri":"spotify:album:6ZWvztYmhLnTowiP1nlq6k","genres":null,"label":"","popularity":0,"artists":[{"id":"1Ewr5BDSftyFLre70T2KY2","name":"Likewise Worship","type":"artist","uri":"spotify:artist:1Ewr5BDSftyFLre70T2KY2"}]},{"album_type":"album","external_urls":{"spotify":"https://open.spotify.com/album/1pzvBxYgT6OVwJLtHkrdQK"},"href":"https://api.spotify.com/v1/albums/1pzvBxYgT6OVwJLtHkrdQK","id":"1pzvBxYgT6OVwJLtHkrdQK","images":[{"url":"https://i.scdn.co/image/ab67616d0000b273c288028c2592f400dd0b9233","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e02c288028c2592f400dd0b9233","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d00004851c288028c2592f400dd0b9233","height":64,"width":64}],"name":"folklore (deluxe version)","release_date":"2020-08-18","type":"album","uri":"spotify:album:1pzvBxYgT6OVwJLtHkrdQK","genres":null,"label":"","popularity":0,"artists":[{"id":"06HL4z0CvFAxyc27GXpf02","name":"Taylor Swift","type":"artist","uri":"spotify:artist:06HL4z0CvFAxyc27GXpf02"}]},{"album_type":"single","external_urls":{"spotify":"https://open.spotify.com/album/50pUZqAPuNWh7pQHToMa7X"},"href":"https://api.spotify.com/v1/albums/50pUZqAPuNWh7pQHToMa7X","id":"50pUZqAPuNWh7pQHToMa7X","images":[{"url":"https://i.scdn.co/image/ab67616d0000b2730e86b8667f3c0c6eeb3a2b8c","height":640,"width":640},{"url":"https://i.scdn.co/image/ab67616d00001e020e86b8667f3c0c6eeb3a2b8c","height":300,"width":300},{"url":"https://i.scdn.co/image/ab67616d000048510e86b8667f3c0c6eeb3a2b8c","height":64,"width":64}],"name":"Speak Now","release_date":"2023-02-24","type":"album","uri":"spotify:album:50pUZqAPuNWh7pQHToMa7X","genres":null,"label":"","popularity":0,"artists":[{"id":"64PR68ehVrXOLufbOS82LE","name":"VinaHouse Bất Diệt","type":"artist","uri":"spotify:artist:64PR68ehVrXOLufbOS82LE"}]}]''';
}
