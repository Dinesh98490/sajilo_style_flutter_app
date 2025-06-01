import 'package:flutter/material.dart';

ThemeData getApplicationTheme(){
  return ThemeData(
      useMaterial3: false,
      primarySwatch: Colors.orange,
      fontFamily: 'Lato Regular', //use lato regular
      appBarTheme: const AppBarTheme(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.orange,
       
      ),
    );
}