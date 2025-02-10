import 'package:aqui_oh_mobile/repos/api.dart';

typedef ReclamacaoRecord = ({
  String id,
  String title,
  String status,
  String competeciaId,
  String userId,
  DateTime createdAt,
  DateTime updatedAt,
  Mensagem? mensagem,
});

typedef Mensagem = ({
  DateTime dth,
  String id,
  String image,
  double lat,
  double lng,
  String text,
  String userId
});

class ReclamacaoRepo {
  static Future<List<ReclamacaoRecord>> listReclamacao({String? title}) async {
    final queryParams = title != null ? {'title': title} : <String, dynamic>{};
    final response = await get('/reclamacao', queryParams);
    return List.from(response)
        .map((reclamacao) => (
              id: reclamacao['id'] as String,
              title: reclamacao['title'] as String,
              status: reclamacao['status'] as String,
              competeciaId: reclamacao['competecia']['id'] as String,
              userId: reclamacao['user']['id'] as String,
              createdAt: DateTime.parse(reclamacao['createdAt'] as String),
              updatedAt: DateTime.parse(reclamacao['updatedAt'] as String),
              mensagem: reclamacao['mensagens'].isEmpty
                  ? null
                  : (
                      id: reclamacao['mensagens'][0]['id'] as String,
                      text: reclamacao['mensagens'][0]['text'] as String,
                      dth: DateTime.parse(
                          reclamacao['mensagens'][0]['dth'] as String),
                      image: reclamacao['mensagens'][0]['image'] as String,
                      lat: reclamacao['mensagens'][0]['lat'] as double,
                      lng: reclamacao['mensagens'][0]['lng'] as double,
                      userId: reclamacao['mensagens'][0]['userId'] as String,
                    )
            ))
        .toList();
  }

  static Future<ReclamacaoRecord> createReclamacao({
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
    final response = await post('/reclamacao', body);
    return (
      id: response['id'] as String,
      title: response['title'] as String,
      status: response['status'] as String,
      competeciaId: response['competecia']['id'] as String,
      userId: response['user']['id'] as String,
      createdAt: DateTime.parse(response['createdAt'] as String),
      updatedAt: DateTime.parse(response['updatedAt'] as String),
      mensagem: response['mensagens'].isEmpty
          ? null
          : (
              id: response['mensagens'][0]['id'] as String,
              text: response['mensagens'][0]['text'] as String,
              dth: DateTime.parse(response['mensagens'][0]['dth'] as String),
              image: response['mensagens'][0]['image'] as String,
              lat: response['mensagens'][0]['lat'] as double,
              lng: response['mensagens'][0]['lng'] as double,
              userId: response['mensagens'][0]['userId'] as String,
            )
    );
  }

  static Future<ReclamacaoRecord> getReclamacao(String reclamacaoId) async {
    final response = await get('/reclamacao/$reclamacaoId');
    return (
      id: response['id'] as String,
      title: response['title'] as String,
      status: response['status'] as String,
      competeciaId: response['competecia']['id'] as String,
      userId: response['user']['id'] as String,
      createdAt: DateTime.parse(response['createdAt'] as String),
      updatedAt: DateTime.parse(response['updatedAt'] as String),
      mensagem: response['mensagens'].isEmpty
          ? null
          : (
              id: response['mensagens'][0]['id'] as String,
              text: response['mensagens'][0]['text'] as String,
              dth: DateTime.parse(response['mensagens'][0]['dth'] as String),
              image: response['mensagens'][0]['image'] as String,
              lat: response['mensagens'][0]['lat'] as double,
              lng: response['mensagens'][0]['lng'] as double,
              userId: response['mensagens'][0]['userId'] as String,
            )
    );
  }

  static Future<void> updateReclamacao({
    required String reclamacaoId,
    String? title,
    String? competeciaId,
    String? status,
  }) async {
    final body = <String, dynamic>{};
    if (title != null) body['title'] = title;
    if (competeciaId != null) body['competeciaId'] = competeciaId;
    if (status != null) body['status'] = status;
    await put('/reclamacao/$reclamacaoId', body);
  }

  static Future<void> deleteReclamacao(String reclamacaoId) async {
    await delete('/reclamacao/$reclamacaoId');
  }
}
