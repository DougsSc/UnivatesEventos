import 'package:flutter/material.dart';

class UniButton extends StatelessWidget {
  String text;
  Function onPressed;
  bool showProgress;
  Color color;

  UniButton(
    this.text, {
    this.onPressed,
    this.showProgress = false,
    this.color = const Color(0xffFF7800),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: RaisedButton(
        color: color,
        disabledColor: color,
        onPressed: showProgress ? null : onPressed,
        child: showProgress ? _loader() : _text(),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
        ),
      ),
    );
  }

  _text() {
    return Text(
      text.toLowerCase(),
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    );
  }

  _loader() {
    return Container(
      width: 30,
      height: 30,
      padding: EdgeInsets.all(2),
      child: CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(Colors.white)),
    );
  }
}
