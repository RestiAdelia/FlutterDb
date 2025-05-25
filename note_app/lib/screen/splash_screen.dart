import 'package:flutter/material.dart';
import 'package:note_app/screen/home_note_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center, // Ini penting!
          children: [
            Spacer(),
            FadeTransition(
              opacity: _animation,
              child: Center(
                child: Column(
                  children:  [
                    Icon(Icons.note_alt_outlined, size: 80, color: Colors.orange),
                    SizedBox(height: 20),
                    Text(
                      'Notes App',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) =>  HomePage()),
                    );
                  },
                  icon: Icon(Icons.arrow_forward, color: Colors.white),
                  label: Text(
                    'Get Started',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding:EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape:RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 6,
                    shadowColor: Colors.orangeAccent,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
