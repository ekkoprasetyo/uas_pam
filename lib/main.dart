import 'package:flutter/material.dart';
import 'package:uas_pam_app/home_page.dart';
import 'package:uas_pam_app/login.dart';
import 'home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Eko Prasetyo - 20180801185",
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      theme: ThemeData(
          accentColor: Colors.white70
      ),
    );
  }
}