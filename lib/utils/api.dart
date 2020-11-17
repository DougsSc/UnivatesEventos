import 'dart:convert';

class Api {
  static const URL = 'https://ensino.univates.br/~douglas.schneider1/';
}

class ApiResponse<T> {
  bool ok;
  T result;

  ApiResponse.ok(this.result) {
    ok = true;
  }

  ApiResponse.error(this.result) {
    ok = false;
  }
}

class ApiError {
  String codigo;
  String mensagem;

  ApiError({
    this.codigo,
    this.mensagem,
  });

  static final String element = 'error';

  factory ApiError.fromSoap(String str) =>
      ApiError.fromMap(json.decode(str)[element]);

  factory ApiError.fromJson(String str) => ApiError.fromMap(json.decode(str)[element]);

  factory ApiError.fromMap(Map<String, dynamic> json) => ApiError(
    codigo: json["code"].toString() == null ? '00' : json["code"].toString(),
    mensagem: json["msg"] == null ? 'Erro desconhecido' :  json["msg"],
  );
}