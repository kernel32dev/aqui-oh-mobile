import 'package:aqui_oh_mobile/services/api.dart';

class UserService {
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
    final response = await ApiService.post('/signin', body);
    final tokenRefresh = response['token_refresh'] as String;
    final tokenAccess = response['token_access'] as String;
    ApiService.globalRefreshToken.value = tokenRefresh;
    ApiService.globalAccessToken.value = tokenAccess;
  }

  static Future<void> signoff({
    required String email,
    required String password,
  }) async {
    final body = {
      'email': email,
      'password': password,
    };
    await ApiService.post('/signoff', body);
    ApiService.globalAccessToken.value = "";
    ApiService.globalRefreshToken.value = "";
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
    final response = await ApiService.post('/login', body);
    print("token_refresh: ${response['token_refresh']}");
    print("token_access: ${response['token_access']}");
    final tokenRefresh = response['token_refresh'] as String;
    final tokenAccess = response['token_access'] as String;
    ApiService.globalRefreshToken.value = tokenRefresh;
    ApiService.globalAccessToken.value = tokenAccess;
  }
}
