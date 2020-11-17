import 'dart:io';

import 'package:flutter/services.dart';

class AppBarUtils {
  static setSystemBarWhiteColor() {
    if (Platform.isIOS) {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle.light.copyWith(
          statusBarBrightness: Brightness.light,
        ),
      );
    }
  }
}
