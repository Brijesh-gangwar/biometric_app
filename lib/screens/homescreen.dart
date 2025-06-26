
import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
      
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: const Text('Home',style: TextStyle(color: Colors.white),
        )),
        body: const Center(
          child: Text(
            'Welcome to Home Screen!',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}