import 'package:flutter/material.dart';
import 'package:trill/models/userlist.dart';

class UserListsScreen extends StatelessWidget {
  final List<UserList> DisplayList = [
    UserList(name: 'spring serenade', albums: []),
    UserList(name: 'summer symphony', albums: []),
    UserList(name: 'autumn anthems', albums: []),
    UserList(name: 'winter whispers', albums: []),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Lists'),
      ),
      body: ListView.builder(
        itemCount: DisplayList.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
              onTap: () {
                // navigate to the list, pass the associated UserList object
                // which contains all the albums in it
              },
              title: Text(
                DisplayList[index].name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              trailing: Icon(Icons.arrow_forward_outlined, color: Colors.white.withOpacity(0.2))
          );
        },
      ),
    );
  }
}
