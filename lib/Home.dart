import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:math';
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

  _salvarTarefa() {
    String texto = campoTarefa.text;
    Map<String, dynamic> tarefa = Map();
    tarefa["titulo"] = texto;
    tarefa["realizada"] = false;

    setState(() {
      tarefas.add(tarefa);
      campoTarefa.clear();
    });

    _salvarArquivo();
  }

  _salvarArquivo() async {
    //assíncriono pois não se sabe quanto tempo demorará para obtêr-se esses dados
    //recuperar local
    var arquivo = await _getFile();
    String dados = json.encode(tarefas);
    arquivo.writeAsString(dados);
  }

  Future<File> _getFile() async {
    final diretorio = await getApplicationDocumentsDirectory();
    return File(diretorio.path + "/" + "dados.json");
  }

  _lerArquivo() async {
    try {
      var arquivo = await _getFile();
      return arquivo.readAsString();
    } catch (e) {
      print("erro");
      return null;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _lerArquivo().then((dados) {
      tarefas = json.decode(dados);
    });
  }

  //pega o caminho da pasta de arquivos da plataforma em uso

  @override
  Widget build(BuildContext context) {
    print(tarefas.toString());
    return Scaffold(
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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
                        _salvarTarefa();
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
                    final itemx = tarefas[index];
                    return Dismissible(
//                      direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
//                          if(direction == DismissDirection.endToStart)
//                            {
//
//                            }
//                          else if(direction == DismissDirection.startToEnd){
//
//                          }
                          //recuperar ultimo item excluido
                          dynamic ultimo = tarefas[index];

                          //exclui
                          setState(() {
                            tarefas.removeAt(index);
                          });

                          //snackbar com opção de desfazer
                          final snackbar = SnackBar(
                            duration: Duration(seconds: 5),
                            content: Text("Tarefa removida"),
                            action: SnackBarAction(
                              label: "Desfazer",
                              onPressed: (){
                                  setState(() {
                                    tarefas.add(ultimo);
                                  });
                              },
                            ),
                          );
                          Scaffold.of(context).showSnackBar(snackbar);



                          print("oi ${direction}");
                          print("deletado: ${tarefas[index]}" );

                        },
//                        background: Container(
//                          color: Colors.green,
//                          padding: EdgeInsets.all(16),
//                          child: Row(
//                            mainAxisAlignment: MainAxisAlignment.start,
//                            children: <Widget>[
//                              Icon(
//                                Icons.edit,
//                                color: Colors.white,
//                              )
//                            ],
//                          ),
//                        ),
                        background: Container(
                          color: Colors.red,
                          padding: EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Icon(
                                Icons.delete,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),

                        key: Key(itemx.toString()),
                        child: CheckboxListTile(
                          value: tarefas[index]["realizada"],
                          onChanged: (valor) {
                            setState(() {
                              tarefas[index]["realizada"] = valor;
                              _salvarArquivo();
                            });
                          },
                          title: Text(tarefas[index]["titulo"]),
                        ));
                  })),
        ],
      ),
    );
  }
}
