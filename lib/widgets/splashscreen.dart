import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFFFFFFFF),
        body: Center(
          child: SizedBox(
            width: screenWidth * 0.7,
            height: screenWidth * 0.7,
            child: Image.asset("assets/images/logo_kjm_small.png"),
          ),
        ),
      ),
    );
  }
}
