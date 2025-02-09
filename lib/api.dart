import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:observable_ish/observable_ish.dart';

const String baseURL = 'http://192.168.18.249/api';

RxValue<String> globalAccessToken = RxValue("");
RxValue<String> globalRefreshToken = RxValue("");

class UserGrants {
  final String id;
  final String email;
  final String name;
  const UserGrants({
    required this.id,
    required this.email,
    required this.name,
  });
  static UserGrants? parse(String token) {
    try {
      final map = JwtDecoder.decode(token);
      return UserGrants(
        id: map['id'],
        email: map['email'],
        name: map['name'],
      );
    } catch (e) {
      return null;
    }
  }
}

Future<void> signin({
  required String name,
  required String email,
  required String password,
}) async {
  final body = {
    'name': name,
    'email': email,
    'password': password,
  };
  final response = await _post('/signin', body);
  final tokenRefresh = response['token_refresh'] as String;
  final tokenAccess = response['token_access'] as String;
  globalRefreshToken.value = tokenRefresh;
  globalAccessToken.value = tokenAccess;
}

Future<void> signoff({
  required String email,
  required String password,
}) async {
  final body = {
    'email': email,
    'password': password,
  };
  await _post('/signoff', body);
  globalAccessToken.value = "";
  globalRefreshToken.value = "";
}

Future<void> login({
  required String email,
  required String password,
}) async {
  final body = {
    'email': email,
    'password': password,
    'competencia': false,
  };
  final response = await _post('/login', body);
  print("token_refresh: ${response['token_refresh']}");
  print("token_access: ${response['token_access']}");
  final tokenRefresh = response['token_refresh'] as String;
  final tokenAccess = response['token_access'] as String;
  globalRefreshToken.value = tokenRefresh;
  globalAccessToken.value = tokenAccess;
}

Future<
    List<
        ({
          String id,
          String title,
          String status,
          String competeciaId,
          String userId,
          DateTime createdAt,
          DateTime updatedAt
        })>> listReclamacao({String? title}) async {
  final queryParams = title != null ? {'title': title} : <String, dynamic>{};
  final response = await _get('/reclamacao', queryParams);
  return List.from(response)
      .map((reclamacao) => (
            id: reclamacao['id'] as String,
            title: reclamacao['title'] as String,
            status: reclamacao['status'] as String,
            competeciaId: reclamacao['competecia']['id'] as String,
            userId: reclamacao['user']['id'] as String,
            createdAt: DateTime.parse(reclamacao['createdAt'] as String),
            updatedAt: DateTime.parse(reclamacao['updatedAt'] as String),
          ))
      .toList();
}

Future<
    ({
      String id,
      String title,
      String status,
      String competeciaId,
      String userId,
      DateTime createdAt,
      DateTime updatedAt
    })> createReclamacao({
  required String title,
  String? competeciaId,
  required String text,
  required String image,
  required double lat,
  required double lng,
}) async {
  final body = {
    'title': title,
    'competeciaId': competeciaId,
    'text': text,
    'image': image,
    'lat': lat,
    'lng': lng,
  };
  final response = await _post('/reclamacao', body);
  return (
    id: response['id'] as String,
    title: response['title'] as String,
    status: response['status'] as String,
    competeciaId: response['competecia']['id'] as String,
    userId: response['user']['id'] as String,
    createdAt: DateTime.parse(response['createdAt'] as String),
    updatedAt: DateTime.parse(response['updatedAt'] as String),
  );
}

Future<
    ({
      String id,
      String title,
      String status,
      String competeciaId,
      String userId,
      DateTime createdAt,
      DateTime updatedAt
    })> getReclamacao(String reclamacaoId) async {
  final response = await _get('/reclamacao/$reclamacaoId');
  return (
    id: response['id'] as String,
    title: response['title'] as String,
    status: response['status'] as String,
    competeciaId: response['competecia']['id'] as String,
    userId: response['user']['id'] as String,
    createdAt: DateTime.parse(response['createdAt'] as String),
    updatedAt: DateTime.parse(response['updatedAt'] as String),
  );
}

Future<void> updateReclamacao({
  required String reclamacaoId,
  String? title,
  String? competeciaId,
  String? status,
}) async {
  final body = <String, dynamic>{};
  if (title != null) body['title'] = title;
  if (competeciaId != null) body['competeciaId'] = competeciaId;
  if (status != null) body['status'] = status;
  await _put('/reclamacao/$reclamacaoId', body);
}

Future<void> deleteReclamacao(String reclamacaoId) async {
  await _delete('/reclamacao/$reclamacaoId');
}

Future<void> _refresh() async {
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

Future<dynamic> _get(String url, [Map<String, dynamic>? queryParams]) async {
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
  if (!jwtIsExpired(globalAccessToken.value)) {
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

Future<dynamic> _post(String url, [Map<String, dynamic>? body]) async {
  final headers = <String, String>{};
  if (body != null) {
    headers['Content-Type'] = 'application/json';
  }
  if (globalAccessToken.value != "") {
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
  }
  if (!jwtIsExpired(globalAccessToken.value)) {
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

Future<dynamic> _put(String url, [Map<String, dynamic>? body]) async {
  final headers = <String, String>{};
  if (body != null) {
    headers['Content-Type'] = 'application/json';
  }
  if (globalAccessToken.value != "") {
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
  }
  if (!jwtIsExpired(globalAccessToken.value)) {
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

Future<dynamic> _delete(String url) async {
  final headers = <String, String>{};
  if (globalAccessToken.value != "") {
    headers['Authorization'] = 'Bearer ${globalAccessToken.value}';
  }
  if (!jwtIsExpired(globalAccessToken.value)) {
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

bool jwtIsExpired(String token) {
  try {
    return JwtDecoder.isExpired(token);
  } catch (e) {
    return true;
  }
}
