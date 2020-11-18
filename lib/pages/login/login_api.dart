import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/utils/api.dart';

class LoginApi {

  static Future<ApiResponse> login(String login, String password) async {
    print("POST => LoginApi.login($login, $password)");

    /*
    var json = '{ '
        '"id":1, '
        '"token":"${UniqueKey().toString()}", '
        '"name":"Douglas Schneider", '
        '"email":"douglas.schneider1@universo.univates.br", '
        '"cpf":"12345678909", '
        '"image":""'
    '}';
    return ApiResponse.ok(User.fromJson(json)); */

    String url = '${Api.URL}login';

    String body = json.encode({
      'login': login,
      'senha': password,
    });
    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
        return ApiResponse.ok(User.fromJson(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> rememberPassword(email) async {
    print("POST => LoginApi.rememberPassword($email)");

    String url = '${Api.URL}password/remember';

    String body = json.encode({
      'email': email,
    });
    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return ApiResponse.ok(json.decode(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }
}