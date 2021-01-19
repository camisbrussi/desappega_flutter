import 'package:desappega/RouteGenerator.dart';
import 'package:desappega/views/Sales.dart';
import 'package:desappega/views/SplashPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

final ThemeData defaultTheme = ThemeData(
  primaryColor: Color(0xffA61103),
  accentColor: Color (0xff400101),
);

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp (MaterialApp(
    title: "Desappega",
    home: SplashPage(),
    theme: defaultTheme,
    debugShowCheckedModeBanner: false,
  ));
}


