import 'package:flutter/material.dart';
import 'package:flutter_lowfit/features/login/view/login_page.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const LowfitApp());
}

class LowfitApp extends StatelessWidget {
  const LowfitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lowfit',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFF1A1A26),
        fontFamily: GoogleFonts.inter().fontFamily, 
        textTheme: GoogleFonts.interTextTheme(
          Theme.of(context).textTheme,
        ).apply(
          bodyColor: Colors.white,
          displayColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const LoginPage(),
    );
  }
}