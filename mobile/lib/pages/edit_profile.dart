import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';

class EditProfileScreen extends StatefulWidget {
  final String initialNickname;
  final String initialBio;
  final String initialProfilePic;
  final Function onUserChanged;

  const EditProfileScreen({
    super.key,
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
          const SnackBar(content: Text('Failed to update user')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Edit Profile'),
          backgroundColor: Colors.transparent),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.initialNickname,
                decoration: InputDecoration(
                  labelText: 'Nickname',
                  labelStyle: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 20),
              TextFormField(
                initialValue: widget.initialBio,
                decoration: InputDecoration(
                  labelText: 'Biography',
                  labelStyle: const TextStyle(color: Colors.white),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUser,
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
