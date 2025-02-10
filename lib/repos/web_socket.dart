import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:aqui_oh_mobile/repos/api.dart';

class MensagemClient {
  final String id;
  final String text;
  final DateTime dth;
  final String? image;
  final double? lat;
  final double? lng;
  final String userId;

  const MensagemClient({
    required this.id,
    required this.text,
    required this.dth,
    required this.image,
    required this.lat,
    required this.lng,
    required this.userId,
  });
}

class MensagensClient {
  final String url;
  final void Function(MensagemClient message) onMessage;
  WebSocket? _socket;
  bool _isConnected = false;
  int _reconnectAttempts = 0;
  final int maxReconnectAttempts = 5;
  final Duration reconnectDelay = Duration(seconds: 3);

  MensagensClient(String reclamacaoId, this.onMessage): url = '${baseURL.replaceFirst("http", "ws")}/mensagem/$reclamacaoId?auth=Bearer ${globalAccessToken.value}' {
    connect();
  }

  Future<void> connect() async {
    while (_reconnectAttempts < maxReconnectAttempts) {
      try {
        if (_socket != null) {
          _socket!.close();
        }
        final socket = await WebSocket.connect(url);
        _socket = socket;
        _isConnected = true;
        _reconnectAttempts = 0;
        print('Connected to WebSocket');

        socket.listen(
          (data) {
            if (_socket != socket) return;
            final map = jsonDecode(data as String) as Map<String, dynamic>;
            if (map['type'] != "Mensagem") {
              return;
            }
            onMessage(MensagemClient(
              id: map['id'],
              text: map['text'],
              dth: DateTime.parse(map['dth']),
              image: map['image'],
              lat: map['lat'],
              lng: map['lng'],
              userId: map['userId'],
            ));
          },
          onDone: () {
            if (_socket != socket) return;
            _handleDisconnect();
          },
          onError: (error) {
            if (_socket != socket) return;
            _handleError(error);
          },
        );
        break;
      } catch (e) {
        _isConnected = false;
        _reconnectAttempts++;
        print(
            'Connection failed. Retrying in ${reconnectDelay.inSeconds} seconds...');
        await Future.delayed(reconnectDelay);
      }
    }
  }

  void sendMessage({
    required String text,
    String? image,
    double? lat,
    double? lng,
  }) {
    if (_isConnected && _socket != null) {
      _socket!.add(jsonEncode({
        'text': text,
        'image': image,
        'lat': lat,
        'lng': lng,
      }));
      print('Message sent');
    } else {
      print('Cannot send message. WebSocket is not connected.');
    }
  }

  void _handleDisconnect() {
    print('WebSocket disconnected. Attempting to reconnect...');
    _isConnected = false;
    connect();
  }

  void _handleError(error) {
    print('WebSocket error: $error');
    _isConnected = false;
    connect();
  }

  void close() {
    _socket?.close();
    _socket = null;
    _isConnected = false;
    print('WebSocket closed.');
  }
}
