import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_tile/shared/styles/colors.dart';

// Application Theme

ThemeData lightmode = ThemeData(
  // Color Theme
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primarySwatch,
    secondary: secondarySwatch,
  ),
  // Scaffold Theme
  scaffoldBackgroundColor: Colors.white,
  // AppBar
  appBarTheme: AppBarTheme(
    color: primarySwatch,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 25,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: primarySwatch,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  // Icons
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  // Bottom Navigation Bar
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.purple[200],
  ),
  // Floating Action Button
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: primarySwatch,
  ),
  // Text Theme
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  // Tab Bar Theme
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
    labelPadding: EdgeInsets.only(bottom: 10,top:5),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
);
