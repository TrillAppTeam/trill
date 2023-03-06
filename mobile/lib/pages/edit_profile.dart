import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:trill/api/users.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialNickname;
  final String initialBio;
  final String initialProfilePic;
  final Function onUserChanged;

  EditProfileScreen({
    required this.initialNickname,
    required this.initialBio,
    required this.initialProfilePic,
    required this.onUserChanged,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _bio = "";
  String _nickname = "";

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bio = widget.initialBio;
    _nickname = widget.initialNickname;
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final success = await updateCurrUser(
        bio: _bio,
        profilePic: "",
        nickname: _nickname,
      );

      if (success) {
        if (!mounted) return;
        Navigator.pop(context);
        widget.onUserChanged();
      } else {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user')),
        );
      }
    }
  }

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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a nickname';
                  }
                  return null;
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
                onPressed: _updateUser,
                child: Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
