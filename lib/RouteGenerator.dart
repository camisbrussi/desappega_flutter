import 'package:desappega/views/DetailsSale.dart';
import 'package:desappega/views/Sales.dart';
import 'package:desappega/views/Login.dart';
import 'package:desappega/views/MySales.dart';
import 'package:desappega/views/NewSale.dart';
import 'package:desappega/views/Register.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case "/":
        return MaterialPageRoute(builder: (_) => Sales());
      case "/login":
        return MaterialPageRoute(builder: (_) => Login());
      case "/register":
        return MaterialPageRoute(builder: (_) => Register());
      case "/my-sales":
        return MaterialPageRoute(builder: (_) => MySales());
      case "/new-sale":
        return MaterialPageRoute(builder: (_) => NewSale());
      case "/details-sale":
        return MaterialPageRoute(builder: (_) => DetailsSale(args));
      default:
        _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {

    return MaterialPageRoute(
      builder: (_){
        return Scaffold(
          appBar: AppBar(
            title: Text("Tela não encontrada"),
          ),
          body: Center(
            child: Text("Tela não encontrada"),
          )
        );
      }
    );
  }
}
