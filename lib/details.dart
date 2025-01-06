import 'package:flutter/material.dart';

class DetailsScreen extends StatelessWidget {
  final String id;
  const DetailsScreen({required this.id, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalhes')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detalhes para ID: $id'),
            SizedBox.square(
              dimension: 6.0,
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details/$id/messages'),
              child: Text('Ir para Mensagens'),
            ),
          ],
        ),
      ),
    );
  }
}
