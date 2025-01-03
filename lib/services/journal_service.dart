import 'dart:convert';
import 'dart:io';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/webclient.dart';
import 'package:http/http.dart' as http;

class JournalService {
  String url = WebClient.url;
  http.Client client = WebClient().client;

  String getUrl() {
    return "${url}journals/";
  }

  Future<bool> register(Journal journal, String token) async {
    final body = jsonEncode(journal.toMap());
    http.Response response = await client.post(Uri.parse(getUrl()),
        body: body,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode != 201) {
      if (jsonDecode(response.body) == 'jwt expired') {
        throw TokenInvalidException();
      }
      throw HttpException(response.body);
    }

    return response.statusCode == 201;
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await client.get(
        Uri.parse("${url}users/$id/journals"),
        headers: {'Authorization': 'Bearer $token'});

    List<Journal> journals = [];

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == 'jwt expired') {
        throw TokenInvalidException();
      }
      throw HttpException(response.body);
    }

    List<dynamic> result = jsonDecode(response.body);

    for (var map in result) {
      journals.add(Journal.fromMap(map));
    }

    return journals;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    final body = jsonEncode(journal.toMap());

    http.Response response = await client.put(Uri.parse('${getUrl()}$id'),
        body: body,
        headers: {
          'Content-type': 'application/json',
          'Authorization': 'Bearer $token'
        });

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == 'jwt expired') {
        throw TokenInvalidException();
      }
      throw HttpException(response.body);
    }

    return response.statusCode == 200;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await client.delete(Uri.parse('${getUrl()}$id'), headers: { "Authorization": 'Bearer $token' });

    if (response.statusCode != 200) {
      if (jsonDecode(response.body) == 'jwt expired') {
        throw TokenInvalidException();
      }
      throw HttpException(response.body);
    }

    return response.statusCode == 200;
  }
}

class TokenInvalidException implements Exception{}