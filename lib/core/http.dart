import 'dart:convert';
import 'package:spotter/core/storage.dart';

import 'package:http/http.dart' as http;

// class HttpRequest extends http.BaseRequest {
//   HttpRequest(String method, Uri url) : super(method, url);

// }

class HttpClient {
  String url;
  Map<String, String> headers = {};
  final SecureStorage storage = SecureStorage();

  HttpClient(String url) {
    this.url = url;
  }

  Future<Map<String, dynamic>> get(String uri,
      {bool withAuthHeaders = false}) async {
    if (withAuthHeaders) {
      await addBasicHeaders();
    }
    http.Response result =
        await http.get(Uri.parse('$url$uri'), headers: headers);
    if (result.statusCode == 200) {
      print(result.statusCode);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(result.body);
    } else if (result.statusCode == 403) {
      // print(result.statusCode);
      throw Exception("Invalid session");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(jsonDecode(result.body)['error']);
    }
  }

  Future<Map<String, dynamic>> post(String uri, body,
      {bool withAuthHeaders = false}) async {
    if (withAuthHeaders) {
      await addBasicHeaders();
    }
    http.Response result = await http.post(Uri.parse('$url$uri'),
        headers: headers, body: jsonEncode(body));
    if (result.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(result.body);
      return jsonDecode(result.body);
    } else if (result.statusCode == 403) {
      print(result.statusCode);
      throw Exception("Invalid session");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // print(result.body);
      throw Exception(jsonDecode(result.body)['error']);
    }
  }

  Future<Map<String, dynamic>> delete(String uri,
      {bool withAuthHeaders = false}) async {
    if (withAuthHeaders) {
      await addBasicHeaders();
    }
    http.Response result =
        await http.delete(Uri.parse('$url$uri'), headers: headers);
    if (result.statusCode == 200) {
      print(result.statusCode);
      // If the server did return a 200 OK response,
      // then parse the JSON.
      return jsonDecode(result.body);
    } else if (result.statusCode == 403) {
      // print(result.statusCode);
      throw Exception("Invalid session");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception(jsonDecode(result.body)['error']);
    }
  }

  Future<Map<String, dynamic>> patch(String uri, body,
      {bool withAuthHeaders = false}) async {
    if (withAuthHeaders) {
      await addBasicHeaders();
    }
    http.Response result = await http.patch(Uri.parse('$url$uri'),
        headers: headers, body: jsonEncode(body));
    if (result.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // print(result.body);
      return jsonDecode(result.body);
    } else if (result.statusCode == 403) {
      print(result.statusCode);
      throw Exception("Invalid session");
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      // print(result.body);
      throw Exception(jsonDecode(result.body)['error']);
    }
  }

  addBasicHeaders() async {
    String token = await storage.getUserToken();
    String permalink = await storage.getPermalink();
    String deviceId = await storage.getDeviceId();
    headers["Authorization"] = 'Bearer $token';
    headers["SpotterUserId"] = permalink;
    headers["SpotterDeviceId"] = deviceId;
    headers["content-type"] = "application/json";
  }
}
