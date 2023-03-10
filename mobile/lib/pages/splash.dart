import 'package:flutter/material.dart';
import 'package:trill/pages/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1B29),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          FractionallySizedBox(
            heightFactor: 0.6,
            child: ShaderMask(
              shaderCallback: (rect) {
                return const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black, Colors.transparent],
                ).createShader(
                    Rect.fromLTRB(0, rect.height / 2, rect.width, rect.height));
              },
              blendMode: BlendMode.dstIn,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('images/beatles.png'),
                    fit: BoxFit.cover,
                    opacity: .5,
                  ),
                ),
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                flex: 4,
                child: Container(),
              ),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Image.asset(
                      'images/logo.png',
                      width: 250,
                    ),
                    const SizedBox(
                      child: Text(
                        'Track albums you\'ve listened to.\n'
                        'Save those you want to hear.\n'
                        'Tell your friends what\'s good.',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          height: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Login(),
                          ),
                        );
                      },
                      child: const Text('Get Started'),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
