import 'package:aqui_oh_mobile/models/mensagem.dart';

class Reclamacao {
  final String id;
  final String title;
  final String status;
  final String competeciaId;
  final String userId;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Mensagem? mensagem;
  const Reclamacao({
    required this.id,
    required this.title,
    required this.status,
    required this.competeciaId,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.mensagem,
  });
  static Reclamacao cast(dynamic dyn) {
    final map = dyn as Map<String, dynamic>;
    return Reclamacao(
        id: map['id'] as String,
        title: map['title'] as String,
        status: map['status'] as String,
        competeciaId: map['competecia']['id'] as String,
        userId: map['user']['id'] as String,
        createdAt: DateTime.parse(map['createdAt'] as String),
        updatedAt: DateTime.parse(map['updatedAt'] as String),
        mensagem: map['mensagens'].isEmpty
            ? null
            : Mensagem.cast(map['mensagens'][0]));
  }
}
