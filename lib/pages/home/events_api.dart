import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:minicurso/entitys/event.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/utils/api.dart';

class EventsApi {
  static Future<ApiResponse> list() async {
    print("POST => EventsApi.list()");

    String url = '${Api.URL}events';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
    });

    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      final list = json.decode(response.body);
      return ApiResponse.ok(list.map<Event>((map) => Event.fromMap(map)).toList());
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }
}