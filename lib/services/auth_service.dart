import 'dart:convert';
import 'dart:io';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  String url = WebClient.url;
  http.Client client = WebClient().client;

  Future<Map<String, dynamic>> login({ required String email, required String password }) async {
    http.Response response = await client.post(Uri.parse('${url}login'), body: {
      'email': email,
      'password': password
    });

    Map<String, dynamic> validation = <String, dynamic>{};

    if (response.statusCode != 200) {
      validation['success'] = false;
      String content = jsonDecode(response.body);
      validation['content'] = content;
    }
    validation['success'] = true;

    saveUserInfos(response.body);

    return validation;
  }

  Future<bool> register({ required String email, required String password }) async {
    http.Response response = await client.post(Uri.parse('${url}users'), body: {
      'email': email,
      'password': password
    });

    if (response.statusCode != 201) {
      throw HttpException(response.body);
    }

    saveUserInfos(response.body);

    return true;
  }

  saveUserInfos(String body) async {
    Map<String, dynamic> map = jsonDecode(body);

    String token = map['accessToken'];
    String email = map['user']['email'];
    int id = map['user']['id'];

    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('accessToken', token);
    preferences.setString('email', email);
    preferences.setInt('id', id);
  }
}