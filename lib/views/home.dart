import 'package:aqui_oh_mobile/controllers/home.dart';
import 'package:aqui_oh_mobile/models/user.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final User user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => HomeScreenState();
}
