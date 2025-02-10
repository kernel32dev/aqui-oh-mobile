import 'package:aqui_oh_mobile/controllers/mapa.dart';
import 'package:aqui_oh_mobile/repos/reclamacao.dart';
import 'package:flutter/material.dart';

class Mapa extends StatefulWidget {
  final List<ReclamacaoRecord> list;
  const Mapa(this.list, {super.key});

  @override
  State<Mapa> createState() => MapaState();
}
