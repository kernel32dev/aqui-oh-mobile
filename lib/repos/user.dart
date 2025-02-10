import 'package:aqui_oh_mobile/repos/api.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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

class UserRepo {
  static Future<void> signin({
    required String name,
    required String email,
    required String password,
  }) async {
    final body = {
      'name': name,
      'email': email,
      'password': password,
    };
    final response = await post('/signin', body);
    final tokenRefresh = response['token_refresh'] as String;
    final tokenAccess = response['token_access'] as String;
    globalRefreshToken.value = tokenRefresh;
    globalAccessToken.value = tokenAccess;
  }

  static Future<void> signoff({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };
    await post('/signoff', body);
    globalAccessToken.value = "";
    globalRefreshToken.value = "";
  }

  static Future<void> login({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
      'competencia': false,
    };
    final response = await post('/login', body);
    print("token_refresh: ${response['token_refresh']}");
    print("token_access: ${response['token_access']}");
    final tokenRefresh = response['token_refresh'] as String;
    final tokenAccess = response['token_access'] as String;
    globalRefreshToken.value = tokenRefresh;
    globalAccessToken.value = tokenAccess;
  }
}
