import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30.0,
            vertical: 30.0
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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
              SizedBox(height: 15),
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
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.pushNamed(context, '/followers')
                          ),
                        ),
                      ),
                    ),
                    Spacer(flex: 2),
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
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
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
              SizedBox(height: 15),
              Container(
                child: Row(
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("455"),
                          Text("Total Albums", style: TextStyle(fontSize: 11))
                        ]
                    ),
                    Spacer(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("3"),
                          Text("Albums This Year", style: TextStyle(fontSize: 11))
                        ]
                    ),
                    Spacer(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("30"),
                          Text("Lists", style: TextStyle(fontSize: 11))
                        ]
                    ),
                    Spacer(),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("5"),
                          Text("Reviews", style: TextStyle(fontSize: 11))
                        ]
                    ),
                  ]
                )
              ),
              SizedBox(height: 15),
              Center(
                child: Text(
                  "Matthew's Favorite Albums",
                  style: TextStyle(
                    fontWeight: FontWeight.bold
                  )
                )
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Image.asset(
                    'images/DierksBentleyTest.jpg',
                    width: 65
                  ),
                  Spacer(),
                  Image.asset(
                    'images/DierksBentleyTest.jpg',
                      width: 65
                  ),
                  Spacer(),
                  Image.asset(
                    'images/DierksBentleyTest.jpg',
                      width: 65
                  ),
                  Spacer(),
                  Image.asset(
                    'images/DierksBentleyTest.jpg',
                      width: 65
                  )
                ]
              ),
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
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                  Spacer(),
                  Text(
                    "See All",
                    style: TextStyle(fontSize: 11),
                  ),
                ],
              ),
              SizedBox(height: 15),
              Row(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        'images/DierksBentleyTest.jpg',
                        width: 65
                      ),
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
                    ]
                  ),
                  Spacer(),
                  Column(
                      children: [
                        Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65
                        ),
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
                      ]
                  ),
                  Spacer(),
                  Column(
                      children: [
                        Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65
                        ),
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
                      ]
                  ),
                  Spacer(),
                  Column(
                      children: [
                        Image.asset(
                            'images/DierksBentleyTest.jpg',
                            width: 65
                        ),
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
                      ]
                  ),
                ]
              ),
              SizedBox(height: 25),
              Row(
                children: [
                  Text(
                    "Matthew's Recent Reviews",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
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
                padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                color: Color(0x1A1B29D7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Dierks Bentley",
                              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)
                            ),
                            Text(" 2003",
                                style: TextStyle(color: Colors.grey, fontSize: 11)
                            ),
                          ]
                        ),
                        SizedBox(height: 2),
                        Row(
                            children: [
                              Text("Reviewed by ",
                                  style: TextStyle(fontSize: 9)
                              ),
                              Text("Matthew ",
                                  style: TextStyle(color: Colors.blue, fontSize: 9)
                              ),
                              Icon(Icons.star, color: Colors.white, size: 10),
                              Icon(Icons.star, color: Colors.white, size: 10),
                              Icon(Icons.star, color: Colors.white, size: 10),
                            ]
                        ),
                        SizedBox(height: 2),
                        Text("What was I thinkin'? Frederick Dierks Bentley",
                            style: TextStyle(fontSize: 9),
                        )
                      ]
                    ),
                    Spacer(),
                    Container(
                      child: Image.asset("images/DierksBentleyTest.jpg", width: 100)
                    ),
                  ]
                ),
              )
            ]
        )
        )
      )
    );
  }
}
