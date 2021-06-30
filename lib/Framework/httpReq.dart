import 'dart:convert';

import 'package:app/Framework/WebSchemas/Session.dart';
import 'package:http/http.dart' as http;

const String _BASE_URL = "https://agile-wave-85046.herokuapp.com";

Future<bool> createSession(String sessionName) async {
  final response =
      await http.get(Uri.parse("$_BASE_URL/createSession?name=$sessionName"));

  return response.statusCode == 200;
}

Future<Session?> getSession(String sessionName) async {
  final response =
      await http.get(Uri.parse("$_BASE_URL/session?name=$sessionName"));

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    return Session.fromJson(responseBody);
  } else {
    return null;
  }
}

Future<bool> checkSession(Session session) async {
  final response = await http.get(Uri.parse(
      "$_BASE_URL/session/check?name=${session.name}&version=${session.lastModified}"));

  print(response.body);

  return response.statusCode == 200 && response.body == "true";
}

Future<Session?> updateSession(Session session) async {
  final postBody = <String, String>{"content": session.content};

  final response = await http.post(
      Uri.parse("$_BASE_URL/session/update?name=${session.name}"),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(postBody));

  if (response.statusCode == 200) {
    Map<String, dynamic> responseBody = jsonDecode(response.body);

    return Session.fromJson(responseBody);
  } else {
    return null;
  }
}
