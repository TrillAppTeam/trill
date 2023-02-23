import 'dart:async';
import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:flutter_login/flutter_login.dart';

class ConfirmScreen extends StatefulWidget {
  final SignupData data;

  ConfirmScreen(this.data);

  @override
  State<ConfirmScreen> createState() => _ConfirmState();
}

class _ConfirmState extends State<ConfirmScreen> {
  final _controller = TextEditingController();
  bool _isEnabled = false;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isEnabled = _controller.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _verifyCode(BuildContext context, SignupData data, String code,
      VoidCallback onSuccess) async {
    try {
      final res = await Amplify.Auth.confirmSignUp(
          username: data.name!, confirmationCode: code);
      if (res.isSignUpComplete) {
        final user = await Amplify.Auth.signIn(
          username: data.name!,
          password: data.password,
        );
        if (user.isSignedIn) {
          onSuccess.call();
        }
      }
    } on AuthException catch (e) {
      _showSnackBar(context, e.message, Colors.redAccent);
    }
  }

  Future<void> _resendCode(
      BuildContext context, SignupData data, VoidCallback onSuccess) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: data.name!);
      onSuccess.call();
    } on AuthException catch (e) {
      _showSnackBar(context, e.message, Colors.redAccent);
    }
  }

  void _showSnackBar(
      BuildContext context, String error, Color backgroundColor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: backgroundColor,
        content: Text(
          error,
          style: TextStyle(fontSize: 15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1F1D36),
      body: Center(
        child: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(children: [
            SizedBox(height: 40),
            Image.asset(
              'images/logo.png',
              width: 180,
            ),
            Card(
              elevation: 12,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              margin: const EdgeInsets.all(30),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    SizedBox(height: 10),
                    TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAAAAAA), width: 3),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xFFAAAAAA), width: 3),
                        ),
                        iconColor: Color(0xFF3FBCF4),
                        focusColor: Color(0xFF3FBCF4),
                        contentPadding:
                            const EdgeInsets.symmetric(vertical: 4.0),
                        prefixIcon: Icon(Icons.lock),
                        labelText: 'Confirmation Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40)),
                        ),
                      ),
                      style: TextStyle(color: Color(0xFF666666)),
                    ),
                    SizedBox(height: 10),
                    MaterialButton(
                      onPressed: _isEnabled
                          ? () {
                              _verifyCode(
                                  context, widget.data, _controller.text, () {
                                if (!mounted) {
                                  return;
                                }
                                Navigator.pushReplacementNamed(
                                    context, '/main');
                              });
                            }
                          : null,
                      elevation: 4,
                      color: Color(0xFF3FBCF4),
                      disabledColor: Color(0xFF3FBCF4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: EdgeInsets.fromLTRB(25, 12, 25, 12),
                      child: Text(
                        'CONFIRM',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        _resendCode(context, widget.data, () {
                          _showSnackBar(
                              context,
                              'Email confirmation code resent',
                              Colors.blueAccent);
                        });
                      },
                      child: Text(
                        'Resend Code',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
