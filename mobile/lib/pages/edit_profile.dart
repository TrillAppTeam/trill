import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trill/api/users.dart';

import '../api/reviews.dart';

class EditProfileScreen extends StatefulWidget {
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _bio = "";
  String _nickname = "";

  final _formKey = GlobalKey<FormState>();

  /*Future<void> _submitReview() async {

    if (response.statusCode == 200) {
      // Review submitted successfully
      Navigator.pop(context);
    } else {
      // Review submission failed
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to submit review'),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Profile'),
          backgroundColor: Colors.transparent
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.grey[900],
                  filled: true
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _nickname = value;
                  });
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Biography',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.grey[900],
                  filled: true
                ),
                keyboardType: TextInputType.multiline,
                onChanged: (value) {
                  setState(() {
                    _bio = value;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState != null) {
                    updateCurrUser(bio: _bio, profilePic: "", nickname: _nickname);
                    Navigator.pop(context);
                  }
                },
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
