import 'dart:io';

import 'package:flutter/material.dart';
import 'package:trill/api/users.dart';
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  final User initialUser;
  final Function onUserChanged;

  const EditProfileScreen({
    super.key,
    required this.initialUser,
    required this.onUserChanged,
  });

  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final picker = ImagePicker();
  String _bio = "";
  String _nickname = "";
  XFile? _profilePic;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _bio = widget.initialUser.bio;
    _nickname = widget.initialUser.nickname;
  }

  void _updateUser() async {
    if (_formKey.currentState!.validate()) {
      final success = await updateCurrUser(
        nickname: _nickname,
        bio: _bio,
        profilePic: _profilePic,
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
      backgroundColor: const Color(0xFF1A1B29),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: GestureDetector(
        onTap: () {
          final FocusScopeNode currentScope = FocusScope.of(context);
          if (!currentScope.hasPrimaryFocus && currentScope.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SizedBox(height: 20),
                Row(
                  children: const [
                    Spacer(),
                    Text(
                      'Trill Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer()
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Showcase your personality by customizing your profile page.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      buildNameField(),
                      const SizedBox(height: 30),
                      buildBioField(),
                      const SizedBox(height: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Profile Picture',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Maximum upload file size: 8 MB',
                            style: TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 10),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                backgroundImage: _profilePic != null
                                    ? FileImage(File(_profilePic?.path ??
                                        "images/DierksBentleyTest.jpg"))
                                    : NetworkImage(
                                            widget.initialUser.profilePicURL)
                                        as ImageProvider,
                                radius: 32.0,
                                backgroundColor: Colors.grey[100],
                              ),
                              const SizedBox(width: 15),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    await _selectImageSource(context);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.grey[700],
                                    backgroundColor: Colors.white,
                                    elevation: 2.0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.0),
                                      side: BorderSide(
                                        color: Colors.grey[300]!,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 10,
                                      horizontal: 15,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.upload_file,
                                          color: Colors.grey[900],
                                          size: 16,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Upload a file',
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.grey[900],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      _buildSaveButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _buildSaveButton() {
    return Container(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
        onPressed: _updateUser,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF06B6D4),
          padding: const EdgeInsets.symmetric(horizontal: 40),
        ),
        child: const Text(
          'Save',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Column buildBioField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Bio',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[100],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            initialValue: widget.initialUser.bio,
            maxLines: 3,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'My life, through music.',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
            ),
            keyboardType: TextInputType.multiline,
            onChanged: (value) {
              setState(() {
                _bio = value;
              });
            },
          ),
        ),
      ),
    ]);
  }

  Column buildNameField() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        'Name',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.grey[100],
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.grey.shade300,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: TextFormField(
            initialValue: widget.initialUser.nickname,
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Taylor',
              hintStyle: TextStyle(
                color: Colors.grey[400],
                fontSize: 14,
              ),
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
        ),
      ),
    ]);
  }

  Future<void> _selectProfilePicFromCamera() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera, // Set default to camera
    );
    if (pickedFile == null) {
      return;
    }

    setState(() {
      _profilePic = XFile(pickedFile.path);
    });
  }

  Future<void> _selectProfilePicFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile == null) {
      return;
    }

    setState(() {
      _profilePic = XFile(pickedFile.path);
    });
  }

  Future<void> _selectImageSource(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          backgroundColor: Colors.black,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text("Select a source"),
          children: [
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                _selectProfilePicFromGallery();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.photo_library, color: Colors.blue),
                    SizedBox(width: 16),
                    Text("Gallery", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.of(context).pop();
                _selectProfilePicFromCamera();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: const [
                    Icon(Icons.camera_alt, color: Colors.blue),
                    SizedBox(width: 16),
                    Text("Camera", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
