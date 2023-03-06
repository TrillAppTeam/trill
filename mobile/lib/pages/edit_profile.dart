import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trill/api/users.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialNickname;
  final String initialBio;
  final String initialProfilePic;

  EditProfileScreen(
      {required this.initialNickname,
      required this.initialBio,
      required this.initialProfilePic});

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _bio = "";
  String _nickname = "";

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Edit Profile'), backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              TextFormField(
                initialValue: widget.initialNickname,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.grey[900],
                  filled: true,
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
                initialValue: widget.initialBio,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  labelStyle: TextStyle(color: Colors.white),
                  fillColor: Colors.grey[900],
                  filled: true,
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
                    updateCurrUser(
                      bio: _bio,
                      profilePic: "",
                      nickname: _nickname,
                    );
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
