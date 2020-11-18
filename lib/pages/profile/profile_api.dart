import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:minicurso/entitys/user.dart';
import 'package:minicurso/utils/session.dart' as session;
import 'package:minicurso/utils/api.dart';

class ProfileApi {

  static Future<ApiResponse> data() async {
    print("POST => data()");

    String url = '${Api.URL}data';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
    });
//    print('Body: $body');

    http.Response response = await http.post(url, body: body);

    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return ApiResponse.ok(User.fromJson(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> changePassword(
      String password, String newPassword) async {
    print("POST => changePassword($password, $newPassword)");

    String url = '${Api.URL}password/change';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
      'senha': password,
      'novaSenha': newPassword,
    });

    http.Response response = await http.post(url, body: body);

//    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return ApiResponse.ok(User.fromJson(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> profile({String name, String newEmail, File photo}) async {
    print("POST => changePassword($name, $newEmail, ${photo != null})");

    String base64Photo = '';
    if (photo != null) {
      List<int> imageBytes = photo.readAsBytesSync();
      base64Photo = base64Encode(imageBytes);
    }

    String url = '${Api.URL}profile';

    var map = {
      'email': session.user.email,
      'token': session.user.token,
    };

    if (name != null) map.addAll({'name': name});
    if (newEmail != null) map.addAll({'email': newEmail});
    if (photo != null) map.addAll({'image': base64Photo});

    String body = json.encode(map);
//    debugPrint('Body: $body');

    http.Response response = await http.post(url, body: body);

//    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return ApiResponse.ok(User.fromJson(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }

  static Future<ApiResponse> logout() async {
    print("POST => ProfileApi.logout()");

    String url = '${Api.URL}logout';

    String body = json.encode({
      'email': session.user.email,
      'token': session.user.token,
    });
//    print('Body: $body');

    http.Response response = await http.post(url, body: body);

//    print('Response Body: ${response.body}');
    if (response.statusCode == 200) {
      return ApiResponse.ok(User.fromJson(response.body));
    } else {
      return ApiResponse.error(ApiError.fromJson(response.body));
    }
  }
}
