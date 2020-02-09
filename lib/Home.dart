import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List tarefas =
      []; //manipular apenas a lista para salvar/atualizar/excluir etc
  TextEditingController campoTarefa = TextEditingController();

  _salvarArquivo() async {
    //assíncriono pois não se sabe quanto tempo demorará para obtêr-se esses dados
    //recuperar local
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = "market";
    tarefa["realizada"] = false;
    tarefas.add(tarefa);

    final diretorio = await getApplicationDocumentsDirectory();
    var arquivo = File(diretorio.path + "/" + "dados.json");
    String dados = json.encode(tarefas);
    arquivo.writeAsString(dados);
  }

  //pega o caminho da pasta de arquivos da plataforma em uso

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        foregroundColor: Colors.white,
        backgroundColor: Colors.yellow,
        elevation: 10,
        mini: false,
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Adicionar tarefa"),
                  content: TextField(
                    decoration: InputDecoration(
                      labelText: "Digite o conteúdo da tarefa",
                    ),
                    keyboardType: TextInputType.text,
                    controller: campoTarefa,
                    maxLines: 5,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Cancelar"),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        _salvarArquivo();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                );
              });
        },
      ),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: Text("Lista de tarefas"),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: ListView.builder(
                  itemCount: tarefas.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(tarefas[index]),
                    );
                  })),
        ],
      ),
    );
  }
}
