import 'package:flutter/material.dart';

class MessagesScreen extends StatelessWidget {
  final String id;
  const MessagesScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mensagens')),
      body: Center(
        child: Text('Mensagens para ID: $id'),
      ),
    );
  }
}
