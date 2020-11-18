import 'dart:convert';

import 'package:minicurso/utils/helper.dart';
import '../entity.dart';

class CreditCard extends Entity {
  int id;
  String number;
  String validate;
  int secureCode;
  String flag;
  int debit;
  String status;

  CreditCard({
    this.id,
    this.number,
    this.validate,
    this.secureCode,
    this.flag,
    this.debit,
    this.status,
  });

  static const MASTER = 'MASTER';
  static const MAESTRO = 'MAESTRO';
  static const VISA = 'VISA';
  static const VISA_ELECTRON = 'VISA_ELECTRON';
  static const DISCOVER = 'DISCOVER';

  static const ENTITY = 'card';

  factory CreditCard.fromSoap(String str) =>
      CreditCard.fromMap(json.decode(str)[ENTITY]);

  factory CreditCard.fromJson(String str) => CreditCard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  CreditCard.fromMap(Map<String, dynamic> map) {
    id = convertToInt(map['id']);
    number = map['number'];
    validate = map['validate'];
    secureCode = convertToInt(map['secureCode']);
    flag = map['flag'];
    debit = convertToInt(map['debit']);
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['number'] = this.number;
    data['validate'] = this.validate;
    data['secureCode'] = this.secureCode;
    data['flag'] = this.flag;
    data['debit'] = this.debit;
    data['status'] = this.status ?? 'a';
    return data;
  }

  String numberCard() {
    return number.substring(number.length - 4);
  }
}
