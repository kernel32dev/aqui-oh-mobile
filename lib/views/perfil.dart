import 'package:aqui_oh_mobile/repos/api.dart';
import 'package:aqui_oh_mobile/repos/user.dart';
import 'package:flutter/material.dart';

class PerfilScreen extends StatelessWidget {
  final UserGrants user;
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
                globalAccessToken.value = "";
                globalRefreshToken.value = "";
                Navigator.of(context).popAndPushNamed('/login');
              },
              child: Text('Logout'))
        ],
      ),
    );
  }
}
