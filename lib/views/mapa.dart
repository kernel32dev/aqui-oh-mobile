import 'package:aqui_oh_mobile/controllers/mapa.dart';
import 'package:aqui_oh_mobile/models/reclamacao.dart';
import 'package:flutter/material.dart';

class MapaScreen extends StatefulWidget {
  final List<Reclamacao> list;
  const MapaScreen(this.list, {super.key});

  @override
  State<MapaScreen> createState() => MapaScreenState();
}
