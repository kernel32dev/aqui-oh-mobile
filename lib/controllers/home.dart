import 'package:aqui_oh_mobile/models/reclamacao.dart';
import 'package:aqui_oh_mobile/repos/reclamacao.dart';
import 'package:aqui_oh_mobile/views/home.dart';
import 'package:aqui_oh_mobile/views/mapa.dart';
import 'package:aqui_oh_mobile/views/nova_reclamacao.dart';
import 'package:aqui_oh_mobile/views/perfil.dart';
import 'package:flutter/material.dart';

class HomeScreenState extends State<HomeScreen> {
  var reclamacaoFuture = ReclamacaoRepo.listReclamacao();

  List<Reclamacao> list = [];
  Object? error;
  bool loading = false;
  int _currentIndex = 1;

  @override
  void initState() {
    super.initState();
    if (loading) {
      return;
    }
    setState(() {
      loading = true;
    });
    ReclamacaoRepo.listReclamacao().then((x) {
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
        title: Text('Aqui-oh'),
      ),
      body: _page(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (x) => setState(() {
          _currentIndex = x;
        }),
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.pin_drop_rounded),
            label: 'Mapa',
          ),
        ],
      ),
      floatingActionButton: _currentIndex != 1 ? null : FloatingActionButton(
        onPressed: () => NovaReclamacaoDialog.show(context, (x) {
          setState(() {
            list.add(x);
          });
        }),
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _page(int index) {
    if (index == 0) {
      return PerfilScreen(user: widget.user);
    } else if (index == 1) {
      return buildBody();
    } else {
      return MapaScreen(list);
    }
  }

  Widget buildBody() {
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
          onTap: () {
            Navigator.of(context).pushNamed("/reclamacao/${reclamacao.id}");
          },
          title: Text(reclamacao.title),
          subtitle: Text('Status: ${reclamacao.status}'),
        );
      },
    );
  }
}
