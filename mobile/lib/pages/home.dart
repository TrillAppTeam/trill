import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? nickname;
  late SharedPreferences _prefs;

  @override
  void initState() {
    super.initState();
    getSharedPreferences();
  }

  void getSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      nickname = _prefs.getString('nickname')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: double.infinity,
      child: Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nickname != null ? 'hello, $nickname!' : 'hello!',
              style: TextStyle(
                color: Colors.blue,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Popular Albums This Month',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Image links will go here
            SizedBox(height: 20),
            Text(
              'Popular Albums Among Friends',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            // Image links will go here
            SizedBox(height: 20),
            Text(
              'Recent Friends Reviews',
              textDirection: TextDirection.ltr,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                ),
                color: Color(0x1f989696),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '"I wasn\'t a fan at first, but now I can\'t stop listening!"',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                ),
                color: Color(0x1f989696),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '"This album is definitely worth checking out!"',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black38,
                ),
                color: Color(0x1f989696),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Text(
                    '"My name is Wesley Wales Anderson and if I were a music album, this would be me!"',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
