import 'package:flutter/material.dart';
import 'package:trill/models/user.dart';

class FollowersScreen extends StatelessWidget {
  final List<User> Users = [
    User(name: 'John Doe', handle: '@johndoe'),
    User(name: 'John Cena', handle: '@johncena'),
    User(name: 'Willem Dafoe', handle: '@WillemDafoeIsVeryCool'),
    User(name: 'Pablo', handle: '@MountainManPablo'),
  ];

  FollowersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Followers'),
      ),
      body: ListView.builder(
        itemCount: Users.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              onTap: () {
                // navigate to their profile, pass the associated User object
                Navigator.pushNamed(context, '/user');
              },
              title: Text(
                Users[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(Users[index].handle),
              trailing: Icon(Icons.arrow_forward_outlined,
                  color: Colors.white.withOpacity(0.2)));
        },
      ),
    );
  }
}
