import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trill/api/albums.dart';
import 'package:trill/constants.dart';
import 'package:mocktail_image_network/mocktail_image_network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:trill/pages/home.dart';
import 'package:trill/pages/loading_screen.dart';
import 'package:trill/widgets/gradient_text.dart';
import 'package:trill/widgets/news_card.dart';
import 'package:trill/widgets/scrollable_albums_row.dart';

class MockAPI extends Mock implements AlbumsApi {}

// Not a unit test, need HTTPClient
/*class CustomBindings extends AutomatedTestWidgetsFlutterBinding {
  @override
  bool get overrideHttpClient => false;
}*/

void main() {
  //CustomBindings();
  group('HomeScreen widget', () {
    late StatefulWidget homeScreen;
    MockAPI mockAPI = MockAPI();

    setUp(() {
      homeScreen = const MaterialApp(
        home: HomeScreen(
          nickname: 'TestUser',
        ),
      );
    });

    testWidgets('should display loading screen initially',
            (WidgetTester tester) async {
          await tester.pumpWidget(homeScreen);

          final loadingScreenFinder = find.byType(LoadingScreen);

          expect(loadingScreenFinder, findsOneWidget);
        });

    testWidgets('should display popular albums and other content after loading',
            (WidgetTester tester) async {
          // Mock album data
          final albums = [
            SpotifyAlbum(
                name: 'Test Album 1',
                artists: [const SpotifyArtist(name: 'Test Artist 1')],
                images: [
                  const SpotifyImage(
                      url: 'https://testalbum1.com', height: 640, width: 640),
                ],
                id: 'test',
                releaseDate: DateTime(DateTime.tuesday)),
            SpotifyAlbum(
                name: 'Test Album 2',
                artists: [const SpotifyArtist(name: 'Test Artist 2')],
                images: [
                  const SpotifyImage(
                      url: 'https://testalbum2.com', height: 640, width: 640),
                ],
                id: 'test',
                releaseDate: DateTime(DateTime.tuesday)),
          ];

          // Mock album API call
          when(() => mockAPI.getMostPopularAlbums('weekly')).thenAnswer((
              _) async => albums);
          await tester.runAsync(() async => await mockNetworkImages(() async {await tester.pumpWidget(const MaterialApp(
            home: Material(
              child: HomeScreen(
                nickname: 'TestUser',
              ),
            ),
          ));}));

          final img = await tester.runAsync(() async => await createTestImage());
          await tester.pump(const Duration(seconds: 5));

          // Check for popular albums section
          final popularAlbumsFinder = find.text('Popular Albums Globally');
          expect(popularAlbumsFinder, findsOneWidget);

          // Check for Grammy section
          final grammySectionFinder = find.text('Hello, Grammys');
          expect(grammySectionFinder, findsOneWidget);

          // Check for Trill Team Favorites section
          final trillFavoritesFinder = find.text('Trill Team Favorites');
          expect(trillFavoritesFinder, findsOneWidget);

          // Check for Recent News section
          final recentNewsFinder = find.text('Recent News');
          expect(recentNewsFinder, findsOneWidget);

          // Check for news cards
          final newsCardFinder = find.byType(NewsCard);
          expect(newsCardFinder, findsNWidgets(2));

          // Check for user's nickname
          final welcomeTextFinder = find.text('Welcome back,');
          expect(welcomeTextFinder, findsOneWidget);

          final nicknameFinder = find.byWidgetPredicate((widget) =>
          widget is GradientText && widget.text == ' TestUser.');
          expect(nicknameFinder, findsOneWidget);
        });

    // functionality of ScrollableAlbumsRow tested in unit test
    testWidgets(
      'should display album options dropdown and update albums when changed',
          (WidgetTester tester) async {
        final albumsOrder1 = [
          SpotifyAlbum(
              name: 'Test Album 1',
              artists: [const SpotifyArtist(name: 'Test Artist 1')],
              images: [
                const SpotifyImage(
                    url: 'https://testalbum1.com', height: 640, width: 640),
              ],
              id: 'test',
              releaseDate: DateTime(DateTime.tuesday)
          ),
          SpotifyAlbum(
              name: 'Test Album 2',
              artists: [const SpotifyArtist(name: 'Test Artist 2')],
              images: [
                const SpotifyImage(
                    url: 'https://testalbum2.com', height: 640, width: 640),
              ],
              id: 'test',
              releaseDate: DateTime(DateTime.tuesday)
          ),
        ];

        final albumsOrder2 = [
          SpotifyAlbum(
              name: 'Test Album 2',
              artists: [const SpotifyArtist(name: 'Test Artist 2')],
              images: [
                const SpotifyImage(
                    url: 'https://testalbum2.com', height: 640, width: 640),
              ],
              id: 'test',
              releaseDate: DateTime(DateTime.tuesday)
          ),
          SpotifyAlbum(
              name: 'Test Album 1',
              artists: [const SpotifyArtist(name: 'Test Artist 1')],
              images: [
                const SpotifyImage(
                    url: 'https://testalbum1.com', height: 640, width: 640),
              ],
              id: 'test',
              releaseDate: DateTime(DateTime.tuesday)
          ),
        ];

        // Mock album API call
        when(() => mockAPI.getMostPopularAlbums('weekly')).thenAnswer((
            _) async => albumsOrder1);
        when(() => mockAPI.getMostPopularAlbums('monthly')).thenAnswer((
            _) async => albumsOrder2);
        await tester.runAsync(() => tester.pumpWidget(homeScreen));
        await tester.pump(const Duration(seconds: 20));

        expect(find.byType(ScrollableAlbumsRow), findsOneWidget);

        // Find the dropdown button and tap it
        final dropdownFinder = find.byType(DropdownButton);
        await tester.runAsync(() => tester.tap(dropdownFinder));
        await tester.pump(const Duration(seconds: 20));
        // Find the dropdown menu item for monthly and tap it
        final dropdownMenuItemFinder =
        find.descendant(
            of: dropdownFinder, matching: find.byType(DropdownMenuItem));
        final dropdownMenuItemMonthlyFinder = dropdownMenuItemFinder.at(1);
        await tester.runAsync(() => tester.tap(dropdownMenuItemMonthlyFinder));
        await tester.pump(const Duration(seconds: 20));
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        await tester.pump(const Duration(seconds: 20));
        expect(find.byType(ScrollableAlbumsRow), findsOneWidget);
      });
    }
  );
}

