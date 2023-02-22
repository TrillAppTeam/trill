import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:trill/api/follows.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool isFollowing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('User'),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 30.0, vertical: 30.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                          backgroundImage: AssetImage("images/gerber.jpg"),
                          radius: 40.0),
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
                      SizedBox(height: 5),
                      Text(
                          "Dr. Matthew Gerber is a professor of Computer Science at the University of Central Florida. "
                          "He specializes in being quirky.",
                          style: TextStyle(fontSize: 11)),
                      SizedBox(height: 15),
                      Container(
                        child: Row(
                          children: [
                            Spacer(),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFBC6AAB), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Followers: 100',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                            context, '/followers')),
                                ),
                              ),
                            ),
                            Spacer(flex: 1),
                            Container(
                              padding: EdgeInsets.all(5),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Color(0xFFBC6AAB), width: 1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: RichText(
                                  text: TextSpan(
                                      text: 'Following: 100',
                                      style: TextStyle(
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.pushNamed(
                                            context, '/following')),
                                ),
                              ),
                            ),
                            Spacer(),
                            Container(
                              decoration: BoxDecoration(
                                //color: isFollowing ? Colors.green : Color(0xFFBC6AAB),
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    isFollowing = !isFollowing;
                                  });
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: isFollowing
                                      ? Colors.green
                                      : Color(0xFFBC6AAB),
                                ),
                                child: Text(
                                  isFollowing ? 'Following' : 'Follow',
                                  //style: TextStyle(color: isFollowing ? Colors.green : Color(0xFFBC6AAB)),
                                ),
                              ),
                            ),
                            Spacer()
                          ],
                        ),
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("455",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              Text("Total Albums",
                                  style: TextStyle(fontSize: 11))
                            ]),
                        Spacer(),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("3",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFBC6AAB),
                                      fontWeight: FontWeight.bold)),
                              Text("Albums This Year",
                                  style: TextStyle(fontSize: 11))
                            ]),
                        Spacer(),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("30",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold)),
                              Text("Lists", style: TextStyle(fontSize: 11))
                            ]),
                        Spacer(),
                        Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("5",
                                  style: TextStyle(
                                      fontSize: 20,
                                      color: Color(0xFFBC6AAB),
                                      fontWeight: FontWeight.bold)),
                              Text("Reviews", style: TextStyle(fontSize: 11))
                            ]),
                      ]),
                      SizedBox(height: 15),
                      Center(
                          child: Text("Matthew's Favorite Albums",
                              style: TextStyle(fontWeight: FontWeight.bold))),
                      SizedBox(height: 15),
                      Row(children: [
                        Image.asset('images/DierksBentleyTest.jpg', width: 65),
                        Spacer(),
                        Image.asset('images/DierksBentleyTest.jpg', width: 65),
                        Spacer(),
                        Image.asset('images/DierksBentleyTest.jpg', width: 65),
                        Spacer(),
                        Image.asset('images/DierksBentleyTest.jpg', width: 65)
                      ]),
                      SizedBox(height: 15),
                      Divider(
                        color: Colors.grey,
                        height: 2,
                        thickness: 2,
                      ),
                      SizedBox(height: 15),
                      Row(
                        children: [
                          Text(
                            "Matthew's Recent Ratings",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                          Spacer(),
                          Text(
                            "See All",
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Row(children: [
                        Column(children: [
                          Image.asset('images/DierksBentleyTest.jpg',
                              width: 65),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ]),
                        Spacer(),
                        Column(children: [
                          Image.asset('images/DierksBentleyTest.jpg',
                              width: 65),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ]),
                        Spacer(),
                        Column(children: [
                          Image.asset('images/DierksBentleyTest.jpg',
                              width: 65),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ]),
                        Spacer(),
                        Column(children: [
                          Image.asset('images/DierksBentleyTest.jpg',
                              width: 65),
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                              Icon(Icons.star, color: Colors.white, size: 12),
                            ],
                          ),
                        ]),
                      ]),
                      SizedBox(height: 25),
                      Row(
                        children: [
                          Text(
                            "Matthew's Recent Reviews",
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 11),
                          ),
                          Spacer(),
                          Text(
                            "See All",
                            style: TextStyle(fontSize: 11),
                          ),
                        ],
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                        color: Color(0xFF392B3A),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(children: [
                                        Text("Dierks Bentley",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11)),
                                        Text(" 2003",
                                            style: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 11)),
                                      ]),
                                      Row(children: [
                                        Text("Reviewed by ",
                                            style: TextStyle(fontSize: 9)),
                                        Text("Matthew ",
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontSize: 9)),
                                        Icon(Icons.star,
                                            color: Colors.white, size: 10),
                                        Icon(Icons.star,
                                            color: Colors.white, size: 10),
                                        Icon(Icons.star,
                                            color: Colors.white, size: 10),
                                      ]),
                                      SizedBox(height: 5),
                                      Text(
                                          "What was I thinkin'? Frederick Dierks Bentley Password cracking is a term used to describe the penetration of a network, system, or resource"
                                          "with or without the use of tools to ulock a resource that has been secured with a password."
                                          " Password cracking tools may seem like powerful decryptors, but in reality are little more than"
                                          "    fast, sophisticated guessing machines.",
                                          style: TextStyle(fontSize: 9),
                                          maxLines: 6,
                                          overflow: TextOverflow.ellipsis)
                                    ]),
                              ),
                              Container(
                                  padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                                  child: Image.asset(
                                      "images/DierksBentleyTest.jpg",
                                      width: 100)),
                            ]),
                      )
                    ]))));
  }
}
