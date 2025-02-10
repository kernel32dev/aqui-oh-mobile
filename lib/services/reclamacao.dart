import 'package:aqui_oh_mobile/models/reclamacao.dart';
import 'package:aqui_oh_mobile/services/api.dart';

class ReclamacaoService {
  static Future<List<Reclamacao>> listReclamacao({String? title}) async {
    final queryParams = title != null ? {'title': title} : <String, dynamic>{};
    final response = await ApiService.get('/reclamacao', queryParams);
    return List.from(response).map(Reclamacao.cast).toList();
  }

  static Future<Reclamacao> createReclamacao({
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
    final response = await ApiService.post('/reclamacao', body);
    return Reclamacao.cast(response);
  }

  static Future<Reclamacao> getReclamacao(String reclamacaoId) async {
    final response = await ApiService.get('/reclamacao/$reclamacaoId');
    return Reclamacao.cast(response);
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
    await ApiService.put('/reclamacao/$reclamacaoId', body);
  }

  static Future<void> deleteReclamacao(String reclamacaoId) async {
    await ApiService.delete('/reclamacao/$reclamacaoId');
  }
}
