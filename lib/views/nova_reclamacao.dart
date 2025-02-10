import 'package:aqui_oh_mobile/controllers/nova_reclamacao.dart';
import 'package:aqui_oh_mobile/models/reclamacao.dart';
import 'package:flutter/material.dart';

class NovaReclamacaoDialog extends StatefulWidget {
  final void Function(Reclamacao teste) onCreate;

  const NovaReclamacaoDialog({super.key, required this.onCreate});

  static void show(BuildContext context, void Function(Reclamacao teste) onCreate) {
    showDialog(
        context: context,
        builder: (context) => NovaReclamacaoDialog(onCreate: onCreate));
  }

  @override
  State<NovaReclamacaoDialog> createState() => NovaReclamacaoDialogState();
}
