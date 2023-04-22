import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:trill/api/reviews.dart';
import 'package:trill/api/users.dart';
import 'package:trill/pages/profile.dart';
import 'package:trill/widgets/review_tile.dart';
import 'package:trill/widgets/rating_bar.dart';

class MockImageProvider extends Mock implements ImageProvider {}

void main() {

  group('ReviewTile', () {
    Review review = Review(
      reviewID: 1,
      albumID: '123',
      user: const User(username: 'john_doe', profilePicURL: 'https://example.com/user.png', bio: '', nickname: 'john_doe'),
      rating: 4,
      reviewText: 'Great food!',
      isLiked: false,
      likes: 2,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    /*final mockImageProvider = MockImageProvider();
    when(() => mockImageProvider.resolve(any())).thenAnswer(
          (_) => const AssetImage("images/DierksBentleyTest.jpg").resolve(ImageConfiguration.empty),
    );*/

    testWidgets('should display the review information', (tester) async {
      await mockNetworkImages(() async {
        await tester.pumpWidget(MaterialApp(
          home: Scaffold(
            body: ReviewTile(
              review: review,
              onLiked: (liked) {},
            ),
          ),
        ));

        expect(find.text('john_doe'), findsOneWidget);
        expect(find.text('Great food!'), findsOneWidget);
        expect(find.byType(ReviewRatingBar), findsOneWidget);
        expect(find.text('2'), findsOneWidget);
        expect(find.byIcon(Icons.more_vert), findsOneWidget);
      });
    });

    testWidgets('should display the edit and delete options for my own review',
            (tester) async {
          var isEditClicked = false;
          var isDeleteClicked = false;
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: ReviewTile(
                review: review,
                onLiked: (liked) {},
                isMyReview: true,
                onUpdate: (rating, text) {
                },
                onDelete: () {
                  isDeleteClicked = true;
                },
              ),
            ),
          ));

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
          expect(find.text('Delete'), findsOneWidget);

          await tester.tap(find.text('Edit'));
          await tester.pumpAndSettle();

          expect(find.byType(ReviewRatingBar), findsOneWidget);

          await tester.tap(find.text('Save'));

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();

          await tester.tap(find.text('Delete'));
          await tester.pumpAndSettle();

          expect(isDeleteClicked, isTrue);
        });

    testWidgets('should not display the edit and delete options for someone else review',
            (tester) async {
          var isEditClicked = false;
          var isDeleteClicked = false;
          await tester.pumpWidget(MaterialApp(
            home: Scaffold(
              body: ReviewTile(
                review: review,
                onLiked: (liked) {},
                isMyReview: false,
                onUpdate: (rating, text) {
                },
                onDelete: () {
                  isDeleteClicked = true;
                },
              ),
            ),
          ));

          await tester.tap(find.byType(PopupMenuButton<String>));
          await tester.pumpAndSettle();

          expect(find.byIcon(Icons.edit_outlined), findsNothing);
          expect(find.text('Delete'), findsNothing);
          expect(find.text('Report'), findsOneWidget);
    });
  });
}
