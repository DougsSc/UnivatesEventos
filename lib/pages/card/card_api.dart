import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minicurso/entitys/credit_card/credit_card.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/utils/api.dart';

class CardApi {
  static Future<ApiResponse> list() async {
    print("POST => CardApi.listCards()");

    String url = '${Api.URL}list';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
    });

    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      return ApiResponse.ok(list.map<CreditCard>((map) => CreditCard.fromMap(map)).toList());
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> add(CreditCard card) async {
    print("POST => CardApi.add()");

    String url = '${Api.URL}card/add';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
      'cartao': card.toMap(),
    });

    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      return ApiResponse.ok(list.map<CreditCard>((map) => CreditCard.fromMap(map)).toList());
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> delete(CreditCard card) async {
    print("POST => CardApi.delete()");

    String url = '${Api.URL}card/delete';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
      'cartao': card.toMap(),
    });

    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      return ApiResponse.ok(list.map<CreditCard>((map) => CreditCard.fromMap(map)).toList());
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }
}