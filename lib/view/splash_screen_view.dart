import 'package:flutter/material.dart';
import 'dart:async';
import 'package:sajilo_style/view/login.dart';

class SplashScreenView extends StatefulWidget {
  const SplashScreenView({super.key});

  @override
  State<SplashScreenView> createState() => _SplashScreenViewState();
}

class _SplashScreenViewState extends State<SplashScreenView> {
  @override
  void initState() {
    super.initState();
    navigate();
  }

  void navigate(){
    Future.delayed(const Duration(seconds: 3), (){
      Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context) => Login()),
      );
    });
  }

 @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: Colors.orange,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          
          Image.asset(
            
            "assets/logos/logo.png",
            width: 300,  
            height: 300, 
            
          ),
        
        ],
      ),
    ),
  );
}
}