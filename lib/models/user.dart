import 'package:jwt_decoder/jwt_decoder.dart';

class User {
  final String id;
  final String email;
  final String name;
  const User({
    required this.id,
    required this.email,
    required this.name,
  });
  static User? parse(String token) {
    try {
      final map = JwtDecoder.decode(token);
      return User(
        id: map['id'],
        email: map['email'],
        name: map['name'],
      );
    } catch (e) {
      return null;
    }
  }
}