import 'package:aqui_oh_mobile/controllers/reclamacao.dart';
import 'package:aqui_oh_mobile/repos/user.dart';
import 'package:flutter/material.dart';

class ReclamacaoScreen extends StatefulWidget {
  final String id;
  final UserGrants user;
  const ReclamacaoScreen({required this.id, required this.user, super.key});

  @override
  State<ReclamacaoScreen> createState() => ReclamacaoScreenState();
}
