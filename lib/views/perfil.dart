import 'package:aqui_oh_mobile/models/user.dart';
import 'package:aqui_oh_mobile/services/api.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final User user;
  const PerfilScreen({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 100.0,
            color: Colors.blueGrey,
          ),
          Text(
            "Olá, ${user.name}",
            style: TextStyle(fontSize: 40.0),
          ),
          TextButton(
              onPressed: () {
                ApiService.globalAccessToken.value = "";
                ApiService.globalRefreshToken.value = "";
                Navigator.of(context).popAndPushNamed('/login');
              },
              child: Text('Logout'))
        ],
      ),
    );
  }
}
