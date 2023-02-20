import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:map_tile/shared/styles/colors.dart';

ThemeData lightmode = ThemeData(
  colorScheme: ColorScheme.fromSwatch().copyWith(
    primary: primarySwatch,
    secondary: secondarySwatch,
  ),
  scaffoldBackgroundColor: Colors.white,
  appBarTheme: AppBarTheme(
    color: darkSwatch,
    elevation: 0,
    titleTextStyle: const TextStyle(
      fontSize: 25,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: darkSwatch,
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.black,
  ),
  bottomNavigationBarTheme: BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.purple[200],
  ),
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.purple[200],
  ),
  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  ),
  tabBarTheme: const TabBarTheme(
    labelColor: Colors.white,
    labelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
    unselectedLabelStyle: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
    labelPadding: EdgeInsets.only(bottom: 10),
    indicator: UnderlineTabIndicator(
      borderSide: BorderSide(color: Colors.white),
    ),
  ),
);

ThemeData darkmode = ThemeData(
  primarySwatch: Colors.deepOrange,
  scaffoldBackgroundColor: const Color(0xFF333739),
  appBarTheme: const AppBarTheme(
    color: Color(0xFF333739),
    elevation: 0,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 25,
      fontWeight: FontWeight.bold,
    ),
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Color(0xFF333739),
      statusBarIconBrightness: Brightness.light,
    ),
  ),
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    selectedItemColor: Colors.deepOrange,
    unselectedItemColor: Colors.grey,
    backgroundColor: Color(0xFF333739),
    elevation: 20,
  ),
  textTheme: const TextTheme(
      bodyLarge: TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w600,
  )),
);
