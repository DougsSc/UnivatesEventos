import 'dart:convert';

import 'package:minicurso/utils/helper.dart';
import '../entity.dart';

class CreditCard extends Entity {
  int id;
  String numero;
  String validade;
  int codigoSeguranca;
  String bandeira;
  int debito;
  String status;

  CreditCard({
    this.id,
    this.numero,
    this.validade,
    this.codigoSeguranca,
    this.bandeira,
    this.debito,
    this.status,
  });

  static const MASTER = 'MASTER';
  static const MAESTRO = 'MAESTRO';
  static const VISA = 'VISA';
  static const VISA_ELECTRON = 'VISA_ELECTRON';
  static const DISCOVER = 'DISCOVER';

  static const ENTITY = 'cartao';

  factory CreditCard.fromSoap(String str) =>
      CreditCard.fromMap(json.decode(str)[ENTITY]);

  factory CreditCard.fromJson(String str) => CreditCard.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  CreditCard.fromMap(Map<String, dynamic> map) {
    id = convertToInt(map['id']);
    numero = map['numero'];
    validade = map['validade'];
    codigoSeguranca = convertToInt(map['codigoSeguranca']);
    bandeira = map['bandeira'];
    debito = convertToInt(map['debito']);
    status = map['status'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id ?? 0;
    data['numero'] = this.numero;
    data['validade'] = this.validade;
    data['codigoSeguranca'] = this.codigoSeguranca;
    data['bandeira'] = this.bandeira;
    data['debito'] = this.debito;
    data['status'] = this.status ?? 'a';
    return data;
  }

  String numberCard() {
    return numero.substring(numero.length - 4);
  }
}
