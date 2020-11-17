import 'dart:async';

import 'package:flutter/material.dart';
import 'package:minicurso/entitys/ticket.dart';
import 'package:minicurso/widgets/label.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:screen/screen.dart';
import 'package:minicurso/utils/session.dart' as session;

class QrExpanded extends StatefulWidget {
  String qr;

  QrExpanded(this.qr);

  @override
  _QrExpandedState createState() => _QrExpandedState();
}

class _QrExpandedState extends State<QrExpanded>
    with SingleTickerProviderStateMixin {
  double brightness;

  bool isValid = true;

  String get qr => widget.qr;

  @override
  void initState() {
    super.initState();
    _setBrightness();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(elevation: 0),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 64),
          padding: EdgeInsets.only(bottom: 16),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Card(
                  child: Container(
                    padding: EdgeInsets.all(8),
                    child: QrImage(
                      data: qr,
                      version: QrVersions.auto,
                      gapless: false,
                    ),
                  ),
                ),
                UniLabel('Aproxime o QR code', fontSize: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setBrightness() async {
    brightness = await Screen.brightness;
    Screen.setBrightness(1);
  }

  @override
  void dispose() {
    Screen.setBrightness(brightness);
    super.dispose();
  }
}
