import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:observable_ish/observable_ish.dart';

const String baseURL = 'https://aqui-oh.app-pratico.com.br/api';

class ApiService {
  static RxValue<String> globalAccessToken = RxValue("");
  static RxValue<String> globalRefreshToken = RxValue("");

  static Future<void> _refresh() async {
    final response = await http.post(
      Uri.parse("$baseURL/refresh"),
      headers: {'Authorization': 'Bearer ${globalRefreshToken.value}'},
    );
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      globalRefreshToken.value = json['token_refresh'] as String;
      globalAccessToken.value = json['token_access'] as String;
    } else if (response.statusCode != 401) {
      throw Exception(
          'HTTP Request failed with a bad status code ${response.statusCode}');
    }
  }

  static Future<dynamic> get(String url,
      [Map<String, dynamic>? queryParams]) async {
    final headers = <String, String>{};
    if (globalAccessToken.value != "") {
      headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    }
    var uri = Uri.parse(baseURL + url);
    if (queryParams != null) {
      uri = Uri(
          scheme: uri.scheme,
          host: uri.host,
          path: uri.path,
          port: uri.port,
          queryParameters: queryParams);
    }
    if (!_jwtIsExpired(globalAccessToken.value)) {
      final response = await http.get(
        uri,
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode != 401) {
        throw Exception(
            'HTTP Request failed with status code ${response.statusCode}');
      }
    }
    await _refresh();
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    final secondResponse = await http.get(
      uri,
      headers: headers,
    );
    if (secondResponse.statusCode == 200) {
      return jsonDecode(secondResponse.body);
    } else {
      throw Exception(
          'HTTP Request failed with status code ${secondResponse.statusCode}');
    }
  }

  static Future<dynamic> post(String url, [Map<String, dynamic>? body]) async {
    final headers = <String, String>{};
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }
    if (globalAccessToken.value != "") {
      headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    }
    if (!_jwtIsExpired(globalAccessToken.value)) {
      final response = await http.post(
        Uri.parse(baseURL + url),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode != 401) {
        throw Exception(
            'HTTP Request failed with a bad status code ${response.statusCode}');
      }
    }
    await _refresh();
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    final secondResponse = await http.post(
      Uri.parse(baseURL + url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (secondResponse.statusCode == 200) {
      return jsonDecode(secondResponse.body);
    } else {
      throw Exception(
          'HTTP Request failed with a bad status code ${secondResponse.statusCode}');
    }
  }

  static Future<dynamic> put(String url, [Map<String, dynamic>? body]) async {
    final headers = <String, String>{};
    if (body != null) {
      headers['Content-Type'] = 'application/json';
    }
    if (globalAccessToken.value != "") {
      headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    }
    if (!_jwtIsExpired(globalAccessToken.value)) {
      final response = await http.put(
        Uri.parse(baseURL + url),
        headers: headers,
        body: body == null ? null : jsonEncode(body),
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode != 401) {
        throw Exception(
            'HTTP Request failed with status code ${response.statusCode}');
      }
    }
    await _refresh();
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    final secondResponse = await http.put(
      Uri.parse(baseURL + url),
      headers: headers,
      body: jsonEncode(body),
    );
    if (secondResponse.statusCode == 200) {
      return jsonDecode(secondResponse.body);
    } else {
      throw Exception(
          'HTTP Request failed with status code ${secondResponse.statusCode}');
    }
  }

  static Future<dynamic> delete(String url) async {
    final headers = <String, String>{};
    if (globalAccessToken.value != "") {
      headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    }
    if (!_jwtIsExpired(globalAccessToken.value)) {
      final response = await http.delete(
        Uri.parse(baseURL + url),
        headers: headers,
      );
      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else if (response.statusCode != 401) {
        throw Exception(
            'HTTP Request failed with status code ${response.statusCode}');
      }
    }
    await _refresh();
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
    final secondResponse = await http.delete(
      Uri.parse(baseURL + url),
      headers: headers,
    );
    if (secondResponse.statusCode == 200) {
      return jsonDecode(secondResponse.body);
    } else {
      throw Exception(
          'HTTP Request failed with status code ${secondResponse.statusCode}');
    }
  }

  static bool _jwtIsExpired(String token) {
    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      return true;
    }
  }
}
