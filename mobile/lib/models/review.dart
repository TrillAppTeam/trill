import 'package:trill/models/album.dart';
import 'package:trill/models/user.dart';

// will need more fields, this is just for testing
class Review {
  String albumName;
  String artistName;
  int year;
  String userName;
  String reviewBody;
  double starRating;

  Review(this.albumName, this.artistName, this.year, this.userName,
      this.reviewBody, this.starRating);
}