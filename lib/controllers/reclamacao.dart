import 'dart:convert';
import 'package:aqui_oh_mobile/models/mensagem.dart';
import 'package:aqui_oh_mobile/models/reclamacao.dart';
import 'package:aqui_oh_mobile/services/mensagem.dart';
import 'package:aqui_oh_mobile/services/reclamacao.dart';
import 'package:aqui_oh_mobile/views/reclamacao.dart';
import 'package:flutter/material.dart';

class ReclamacaoScreenState extends State<ReclamacaoScreen> {
  String _title = "";
  late Future<Reclamacao> getReclamacaoFuture;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  late MensagemService _mensagensConnection;
  final List<Mensagem> _mensagens = [];

  @override
  void initState() {
    super.initState();
    getReclamacaoFuture = ReclamacaoService.getReclamacao(widget.id)..then((x) {
      setState(() {
        _title = x.title;
      });
    });
    _mensagensConnection = MensagemService(widget.id, (mensagem) {
      setState(() {
        for (int i = 0; i < _mensagens.length; i++) {
          if (_mensagens[i].id == mensagem.id) {
            _mensagens[i] = mensagem;
            return;
          }
        }
        _mensagens.add(mensagem);
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _mensagensConnection.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(_title)),
        body: FutureBuilder(
            future: getReclamacaoFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              final reclamacao = snapshot.data;
              if (reclamacao == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Load: ${snapshot.error}')),
                );
                return Center(
                  child: Text('Ocorreu um erro ao carregar os dados'),
                );
              }
              return _chat(reclamacao);
            }));
  }

  Widget _chat(Reclamacao reclamacao) {
    final myUserId = widget.user.id;
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _mensagens.length,
            itemBuilder: (context, index) {
              final mensagem = _mensagens[index];
              final isMe = mensagem.userId == myUserId;
              // a data url
              String? image = mensagem.image;
              return Align(
                alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isMe ? Colors.blueAccent : Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (image != null && image.isNotEmpty)
                        Image.memory(
                          base64Decode(
                              image.split(',').last), // Decode base64 data
                          width: 200, // Adjust width as needed
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      SizedBox(height: 5),
                      Text(
                        mensagem.text,
                        style: TextStyle(
                          color: isMe ? Colors.white : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: "Digite sua mensagem...",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send, color: Colors.blueAccent),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    setState(() {
                      _mensagensConnection.sendMessage(
                          text: _controller.text.trim());
                    });
                    _controller.clear();
                    _scrollController.animateTo(
                      _scrollController.position.maxScrollExtent,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeOut,
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
