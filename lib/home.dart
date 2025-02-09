import 'package:aqui_oh_mobile/api.dart';
import 'package:aqui_oh_mobile/nova_reclamacao.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  final UserGrants user;
  const HomeScreen({super.key, required this.user});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var reclamacaoFuture = listReclamacao();

  List<
      ({
        String competeciaId,
        DateTime createdAt,
        String id,
        String status,
        String title,
        DateTime updatedAt,
        String userId
      })> list = [];
  Object? error;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    listReclamacao().then((x) {
      setState(() {
        list = x;
        error = null;
        loading = false;
      });
    }).catchError((e) {
      setState(() {
        list = [];
        error = e;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Reclamações'),
      ),
      body: buildBody(context),
      floatingActionButton: FloatingActionButton(
        onPressed: () => NovaReclamacaoDialog.show(context, (x) {
          setState(() {
            list.add(x);
          });
        }),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget buildBody(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    } else if (error != null) {
      return Center(child: Text('Erro ao carregar dados'));
    } else if (list.isEmpty) {
      return Center(child: Text('Nenhuma reclamação encontrada'));
    }
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final reclamacao = list[index];
        return ListTile(
          title: Text(reclamacao.title),
          subtitle: Text('Status: ${reclamacao.status}'),
        );
      },
    );
  }
}
