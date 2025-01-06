import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Home'),
            SizedBox.square(
              dimension: 6.0,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Ir para Login'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              child: Text('Ir para Perfil'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details/1'), // Example ID
              child: Text('Ir para Detalhes #1'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details/2'), // Example ID
              child: Text('Ir para Detalhes #2'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, '/details/3'), // Example ID
              child: Text('Ir para Detalhes #3'),
            ),
          ],
        ),
      ),
    );
  }
}
