import 'package:desappega/utils/nav.dart';
import 'package:flutter/material.dart';
import 'package:desappega/views/Sales.dart';
import 'package:flutter_svg/svg.dart';


class SplashPage extends StatefulWidget {
  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    Future delay = Future.delayed(Duration(seconds: 3));

    Future.wait([delay]).then((List values) {
      pushReplacement(context, Sales());
    });

  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).primaryColor,
      child: Column(
        children: [
          Expanded(child: Container()),
          SvgPicture.asset(
            "images/logo.svg",
            width: 200,
            height: 150,
          ),
          SizedBox(height: 16),
          CircularProgressIndicator(),
          Expanded(child: Container()),
        ],
      ),
    );
  }
}

