import 'package:flutter/material.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: Center(
        child: Image.asset(
          "assets/images/nointernet.jpg",
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
