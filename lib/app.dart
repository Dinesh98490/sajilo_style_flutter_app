import 'package:flutter/material.dart';
import 'package:sajilo_style/view/splash_screen_view.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Sajilo Style",
      debugShowCheckedModeBanner: false,
      
      home: SplashScreenView());
  }
}