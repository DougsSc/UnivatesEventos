import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'session.dart' as session;

String formatCpf(String cpf) {
  if (cpf == null) return null;
  var numeros = cpf.replaceAll(RegExp(r'[^0-9]'), '');
  return "${numeros.substring(0, 3)}.${numeros.substring(3, 6)}.${numeros.substring(6, 9)}-${numeros.substring(9)}";
}

int convertToInt(dynamic value) {
  int number = 0;
  if (value is String) {
    number = int.tryParse(value);
  } else if (value is double) {
    number = value.toInt();
  } else if (value is int) {
    number = value;
  }

  return number;
}

double convertToDouble(dynamic value) {
  double number = 0.0;
  if (value is String) {
    number = double.tryParse(value);
  } else if (value is int) {
    number = value.toDouble();
  } else if (value is double) {
    number = value;
  }

  return number;
}

Image getUserImage({File image}) {
  if (image != null) return Image.file(image, fit: BoxFit.fill);
  if (session.user.image != null && session.user.image.isNotEmpty)
    return Image.network(session.user.image, fit: BoxFit.fill);
  return Image.asset("assets/images/profile.jpg", fit: BoxFit.fill);
}

DateTime parseDate(String date) {
  return DateFormat("yyyy-MM-dd HH:mm:ss").parse(date);
}

String formatDate(String date) {
  return DateFormat('dd/MM/yyyy HH:mm').format(parseDate(date));
}




