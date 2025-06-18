import 'package:flutter/material.dart';


// theme of the app
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  static ThemeData getApplicationTheme({required bool isDarkMode}) {
    return ThemeData(
      // Set the color scheme based on light or dark mode
      colorScheme: isDarkMode
          ? const ColorScheme.dark(primary: Colors.deepOrange)
          : const ColorScheme.light(primary: Colors.orange),

      // Set brightness
      brightness: isDarkMode ? Brightness.dark : Brightness.light,

      // Use custom font
      fontFamily: 'Lato Regular',

      // Disable Material3 to use Material2 styling
      useMaterial3: false,

      // AppBar theme
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: Colors.orange,
        centerTitle: true,
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
      ),

      // Scaffold background color
      scaffoldBackgroundColor: isDarkMode ? Colors.black : Colors.white,

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          foregroundColor: Colors.white,
          backgroundColor: Colors.orange,
          textStyle: const TextStyle(fontSize: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),

      // Text field input decoration theme
      inputDecorationTheme: const InputDecorationTheme(
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(),
        labelStyle: TextStyle(fontSize: 20),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.orange),
        ),
      ),

      // Circular progress indicator color
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: Colors.orange,
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.orange,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
