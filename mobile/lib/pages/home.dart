import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trill'),
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 70),
              Column(children: [
                const Text(
                  'Matthew Gerber',
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('@GerbersGrumblings'),
              ]),
              SizedBox(height: 20),
              Container(
                child: Row(
                  children: [
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFFBC6AAB),
                            width: 1
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                            text: 'Followers: 100',
                            style: TextStyle(fontSize: 11),
                            recognizer: TapGestureRecognizer()
                            ..onTap = () => Navigator.pushNamed(context, '/followers')
                          ),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Color(0xFFBC6AAB),
                            width: 1
                        ),
                        borderRadius: BorderRadius.all(
                            Radius.circular(30)
                        ),
                      ),
                      child: Center(
                        child: RichText(
                          text: TextSpan(
                              text: 'Following: 100',
                              style: TextStyle(fontSize: 11),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(context, '/following')
                          ),
                        ),
                      ),
                    ),
                    Spacer()
                  ],
                ),
              ),
              SizedBox(height: 20),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pushNamed(context, '/main');
                },
              ),
              ListTile(
                title: const Text('Albums'),
                onTap: () {
                  Navigator.pushNamed(context, '/albums');
                },
              ),
              ListTile(
                title: const Text('Reviews'),
                onTap: () {
                  Navigator.pushNamed(context, '/reviews');
                },
              ),
              ListTile(
                title: const Text('Lists'),
                onTap: () {
                  Navigator.pushNamed(context, '/lists');
                },
              ),
              ListTile(
                title: const Text('Likes'),
                onTap: () {
                  Navigator.pushNamed(context, '/likes');
                },
              ),
              SizedBox(height: 30),
              ListTile(
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.pushNamed(context, '/login');
                },
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        child: Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, username!',
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
      ),
    );
  }
}
