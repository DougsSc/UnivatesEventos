import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:minicurso/widgets/button.dart';
import 'package:permission_handler/permission_handler.dart';

import 'alert.dart';

class PermissionService {

  static Future<bool> location(context) async {
    bool isGranted = await Permission.location.request().isGranted;

    if (isGranted) {
      return true;
    } else {
      showBottomQuestion(
        context,
        'Permissão necessária',
        'Este dispositivo não permitiu o acesso a sua localização! Para utilizar o aplicativo acesse suas configurações e libere o acesso a sua localização.',
        UniButton('Configurações', onPressed: () {
          Navigator.pop(context);
          openAppSettings();
        }),
      );
    }

    return false;
  }

  static Future<bool> camera(context) async {
    if (await Permission.camera.request().isGranted) {
      return true;
    } else {
      showBottomQuestion(
        context,
        'Permissão necessária',
        'Este dispositivo não permitiu o acesso a câmera! Para utilizar o aplicativo acesse suas configurações e libere o acesso a sua câmera.',
        UniButton('Configurações', onPressed: () {
          Navigator.pop(context);
          openAppSettings();
        }),
      );
    }

    return false;
  }
}
