import 'package:flutter/material.dart';
import 'package:minicurso/pages/splash_page.dart';

void main() => runApp(
  MaterialApp(
    home: SplashPage(),
    title: 'Eventos',
    theme: ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      primaryColor: const Color(0xff07488c),
      accentColor: const Color(0xFF0092e7),
      canvasColor: Colors.transparent,
    ),
    debugShowCheckedModeBanner: false,
  ),
);