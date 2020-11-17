import 'dart:convert';

import 'package:minicurso/utils/helper.dart';
import 'package:minicurso/utils/prefs.dart';

class Ticket {
  String token;
  String validade;
  int cliente;
  double valorTotal;
  int idLinha;
  String linha;
  int qtdeBilhetes;
  double saldoCliente;
  String qrCode;
  String assinatura;
  int dataEmissao;
  int dataDispositivo;
  int counter;

  Ticket({
    this.token,
    this.validade,
    this.cliente,
    this.valorTotal,
    this.idLinha,
    this.linha,
    this.qtdeBilhetes,
    this.saldoCliente,
    this.qrCode,
    this.assinatura,
    this.dataEmissao,
    this.dataDispositivo,
    this.counter = 1
  });

  static final String element = 'ticket';

  factory Ticket.fromJson(String str) => Ticket.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  Ticket.fromMap(Map<String, dynamic> map) {
    token = map['token'];
    validade = map['validade'];
    cliente = convertToInt(map['cliente']);
    valorTotal = convertToDouble(map['valorTotal']);
    idLinha = convertToInt(map['idLinha']);
    linha = map['linha'];
    qtdeBilhetes = convertToInt(map['qtdeBilhetes']);
    saldoCliente = convertToDouble(map['saldoCliente']);
    qrCode = map['qrCode'];
    assinatura = map['assinatura'];
    dataEmissao = convertToInt(map['dataEmissao']);
    dataDispositivo = map['dataDispositivo'];
    counter = 1;
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['validade'] = this.validade;
    data['cliente'] = this.cliente;
    data['valorTotal'] = this.valorTotal;
    data['idLinha'] = this.idLinha;
    data['linha'] = this.linha;
    data['qtdeBilhetes'] = this.qtdeBilhetes;
    data['saldoCliente'] = this.saldoCliente;
    data['qrCode'] = this.qrCode;
    data['assinatura'] = this.assinatura;
    data['dataEmissao'] = this.dataEmissao;
    data['dataDispositivo'] = this.dataDispositivo;
    return data;
  }

  void save() => Prefs.setString(element, toJson());

  static Future<Ticket> get() async {
    String prefs = await Prefs.getString(element);
    if (prefs.isEmpty) return null;
    return Ticket.fromJson(prefs);
  }

  void remove() => Prefs.setString(element, null);

  void saveFast() => Prefs.setString('fast$element', toJson());

  static Future<Ticket> getFast() async {
    String prefs = await Prefs.getString('fast$element');
    if (prefs.isEmpty) return null;
    return Ticket.fromJson(prefs);
  }

  void removeFast() => Prefs.setString('fast$element', null);

  int nowDiff() {
//    final emission = DateTime.fromMillisecondsSinceEpoch(dataEmissao * 1000);
    final device = DateTime.fromMillisecondsSinceEpoch(dataDispositivo);
    final now = DateTime.now(); // getNowBasedDate(device);

//    final diffSeconds = device.difference(emission).inSeconds;

//    final subNow = now.subtract(Duration(seconds: diffSeconds));
//    final subDev = device.subtract(Duration(seconds: diffSeconds));

    final diffDevice = now.difference(device).inSeconds;

    counter = convertToInt(diffDevice / 15);
    counter += 2;

//    print('Device: $device - Now: $now');
//    print('diffDevice: $diffDevice');
//    print('Counter: $counter');

    return diffDevice;
  }

  int finishDiff() {
    final emission = DateTime.fromMillisecondsSinceEpoch(dataEmissao * 1000);
    final validate = parseDate(validade);
    final device = DateTime.fromMillisecondsSinceEpoch(dataDispositivo);
    final now = DateTime.now();

    final diffSeconds = device.difference(emission).inSeconds;

    final subNow = now.subtract(Duration(seconds: diffSeconds));
    final diff = validate.difference(subNow).inSeconds;

//    print('diff: $diff');

    return diff;
  }

  bool isValid() {
    int dif = nowDiff();
    final generated = DateTime.fromMillisecondsSinceEpoch(dataEmissao * 1000);
    final diffDate = generated.add(Duration(seconds: dif));
    final validDate = parseDate(validade);

    bool isValid =
        diffDate.isAtSameMomentAs(validDate) || diffDate.isBefore(validDate);
//    print('Diff.isValid: $isValid');
    return isValid;
  }
}
