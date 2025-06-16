import 'package:api_user/uiview/list_dosen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 5000,
      splash: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo Bulat
          Container(
            height: 110,
            width: 110,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Colors.white, Colors.white70],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(2, 5),
                )
              ],
            ),
            child: const Center(
              child: Icon(
                Icons.school_rounded,
                size: 60,
                color: Colors.green,
              ),
            ),
          ),
          const SizedBox(height: 30),
          // Title
          Text(
            'CRUD Data App',
            style: GoogleFonts.poppins(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 10),
          // Subtitle
          Text(
            'Aplikasi Kelola Data Dosen',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
      nextScreen: const PageListDosen(),
      splashTransition: SplashTransition.fadeTransition,
      backgroundColor: Colors.green.shade800,
      splashIconSize: 280,
      centered: true,
    );
  }
}
