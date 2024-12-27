import 'dart:convert';

import 'package:flutter_webapi_first_course/models/journal.dart';
import 'package:flutter_webapi_first_course/services/http_interceptors.dart';
import 'package:http/http.dart' as http;
import 'package:http_interceptor/http_interceptor.dart';

class JournalService {
  static const String url = "http://192.168.0.7:3000/";
  static const String resource = "journals/";

  http.Client client =
      InterceptedClient.build(interceptors: [LoggerInterceptor()]);

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal) async {
    final body = jsonEncode(journal.toMap());
    http.Response response = await client.post(Uri.parse(getUrl()),
        body: body, headers: {'Content-type': 'application/json'});
    return response.statusCode == 201;
  }

  Future<List<Journal>> getAll() async {
    http.Response response = await client.get(Uri.parse(getUrl()));

    List<Journal> journals = [];

    if (response.statusCode != 200) {
      throw Exception();
    }

    List<dynamic> result = jsonDecode(response.body);

    for (var map in result) {
      journals.add(Journal.fromMap(map));
    }

    return journals;
  }
}
