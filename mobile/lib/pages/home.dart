import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nickname != null ? 'hello, $nickname!' : 'hello!',
            style: const TextStyle(
              color: Colors.blue,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Popular Albums This Month',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Image links will go here
          const SizedBox(height: 20),
          const Text(
            'Popular Albums Among Friends',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          // Image links will go here
          const SizedBox(height: 20),
          const Text(
            'Recent Friends Reviews',
            textDirection: TextDirection.ltr,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black38,
              ),
              color: const Color(0x1f989696),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Text(
                  '"I wasn\'t a fan at first, but now I can\'t stop listening!"',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black38,
              ),
              color: const Color(0x1f989696),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
                Text(
                  '"This album is definitely worth checking out!"',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.black38,
              ),
              color: const Color(0x1f989696),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              children: const [
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
    );
  }
}
