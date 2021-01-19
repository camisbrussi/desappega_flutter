import 'package:desappega/main.dart';
import 'package:flutter/material.dart';


class CustomButton extends StatelessWidget {

  final String text;
  final Color colorText;
  final VoidCallback onPressed;

  CustomButton({
    @required this.text,
    this.colorText = Colors.white,
    this.onPressed
});

  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6)),
      child: Text(
        this.text,
        style: TextStyle(
            color: this.colorText, fontSize: 20),
      ),
      color: defaultTheme.accentColor,
      padding: EdgeInsets.fromLTRB(32, 16, 32, 16),

      onPressed: this.onPressed,
    );
  }
}
