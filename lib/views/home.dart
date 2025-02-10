import 'package:aqui_oh_mobile/controllers/home.dart';
import 'package:aqui_oh_mobile/repos/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserGrants user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}
