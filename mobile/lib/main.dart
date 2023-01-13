import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(ChangeNotifierProvider(
  create: (context) => TrillBottomNavigatorModel(),
  child: MyApp()
  )
);

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trill',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: Colors.black,
        textTheme: Typography.whiteMountainView,
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(color: Colors.white),
        ),
      ),
      home: SplashScreen(),
      routes: {
        '/login': (context) => LogInScreen(),
        '/signup': (context) => SignUpScreen(),
        '/home': (context) => HomeScreen(),
        '/search': (context) => SearchScreen(),
        '/searchResults': (context) => SearchResultsScreen(),
        '/album': (context) => AlbumScreen(),
        '/review': (context) => ReviewScreen(),
        '/profile': (context) => ProfileScreen()
      },
    );
  }
}

class TrillBottomNavigatorModel with ChangeNotifier {
  int selectedIndex = 0;

  void setSelectedIndex(int index) {
    selectedIndex = index;
    notifyListeners();
  }
}

// This bottom navbar might be inefficient as currently written
// it seems to be hard / not recommended to use just one instance of it across multiple screens
// so the selected index is shared instead
// but it looks nice
// Does not work with the Android device back button
class TrillBottomNavigatorState extends StatelessWidget {
  final GlobalKey key = GlobalKey();
  @override
  Widget build(BuildContext context) {
    final model = Provider.of<TrillBottomNavigatorModel>(context);
    return DefaultTabController(
      length: 3,
      initialIndex: model.selectedIndex,

      child: Theme(
        data: Theme.of(context).copyWith(
          canvasColor: Colors.black,
          textTheme: Theme.of(context).textTheme.copyWith(
            caption: TextStyle(color: Colors.white),
          ),
        ),
        child: TabBar(
          indicator: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Colors.blue, width: 2.0),
            ),
          ),
          labelColor: Colors.purple,
          unselectedLabelColor: Colors.white,
          onTap: (index) {
            model.setSelectedIndex(index);
            DefaultTabController.of(context)?.animateTo(index);
            if (index == 0) {
              Navigator.pushNamed(context, '/home');
            }
            if (index == 1) {
              Navigator.pushNamed(context, '/search');
            }
            if (index == 2) {
              Navigator.pushNamed(context, '/profile');
            }
          },
          tabs: [
            Tab(
              icon: Icon(Icons.home),
            ),
            Tab(
              icon: Icon(Icons.search),
            ),
            Tab(
              icon: Icon(Icons.person),
            ),
          ],
        ),
      ),
    );
  }
}

class SearchResultsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                ListTile(
                  title: Text('Result 1'),
                ),
                ListTile(
                  title: Text('Result 2'),
                ),
                ListTile(
                  title: Text('Result 3'),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }}

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Enter search query',
                border: OutlineInputBorder()
              ),
              onSubmitted: (query) {
                Navigator.pushNamed(context, '/searchResults');
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}

class AlbumScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Album Name'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}

class ReviewScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Write Review'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Username\'s Profile'),
      ),
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: 50),
            Text(
              'Welcome to Trill',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text('Track albums you\'ve listened to. Save those you want to hear.'
                ' Tell your friends what\'s good.',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 50),
            ElevatedButton(
              child: Text('Get Started'),
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
            ),
          ],
        ),
      ),
    )
    );
  }
}

class LogInScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: 30),
            Text('Please sign in to continue.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Login'),
              onPressed: () {
                // Log the user in
                Navigator.pushNamed(context, '/home');
              },
            ),
            SizedBox(height: 10),
            Text('Don\'t have an account? Head to the Sign Up page.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/logo.png'),
            SizedBox(height: 30),
            Text('Create an account to continue.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Username',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Email',
              ),
            ),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                hintText: 'Password',
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              child: Text('Sign Up'),
              onPressed: () {
                // Sign the user up
                Navigator.pushNamed(context, '/');
              },
            ),
            SizedBox(height: 10),
            Text('Already have an account? Head to the login page.',
              style: TextStyle(
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Trill'),
        actions: [IconButton(
          icon: Icon(Icons.search),
          onPressed: (){
            final model = Provider.of<TrillBottomNavigatorModel>(context, listen: false);
            model.setSelectedIndex(1);
            // Open Search Menu
            Navigator.pushNamed(context, '/search');
          },
        )],
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(height: 70),
                Column (
                  children: [
                    const Text( 'Matthew Gerber',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                        ),
                      ),
                  const Text('@GerbersGrumblings'),
                  ]
                ),
              SizedBox(height: 50),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/home');
                },
              ),
              ListTile(
                title: const Text('Reviews'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: const Text('Lists'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              ListTile(
                title: const Text('Likes'),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/profile');
                },
              ),
              SizedBox(height: 30),
              ListTile(
                title: const Text('Log Out'),
                onTap: () {
                  Navigator.pop(context);
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
      bottomNavigationBar: TrillBottomNavigatorState(),
    );
  }
}
