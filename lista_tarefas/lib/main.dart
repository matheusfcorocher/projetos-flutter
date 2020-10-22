import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart';

void main() {
  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.dumpErrorToConsole(details);
    if (kReleaseMode) exit(1);
  };
  runApp(MaterialApp(
    title: "Lista de tarefas",
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _toDoController = TextEditingController();

  List _toDoList = [];
  Map<String, dynamic> _lastRemoved;
  int _lastRemovedPos;

  @override
  void initState() {
    /*O método initState é sempre chamado quando inicializa o estado
  * da tela - CNTRL+O*/
    /*Esse método foi reescrito para reescrever os dados do arquivo json
    * ou as tarefas já colocadas pelo usuário*/
    // chama o classe (pai State<Home>)
    super.initState();

    //chama a função _readData() e usa depois outra função para
    // decodificar a String
    _readData().then((data) {
      setState(() {
        _toDoList = json.decode(data);
      });
    });
  }

  void _addToDo() {
    // Quando for adiciona a tarefa, já atualiza a lista
    setState(() {
      Map<String, dynamic> newToDo = Map();
      newToDo["title"] = _toDoController.text;
      _toDoController.text = "";
      newToDo["ok"] = false;
      _toDoList.add(newToDo);
      _saveData();
    });
  }

  Future<Null> _refresh() async {
    //Espera 1 segundo para demora a ordenação
    await Future.delayed(Duration(seconds: 1));
    setState(() {
      // o metodo .sort(a, b) vai compara um elemento da _toDoList com outro
      // elemento b da própria lista, usando 1,-1 e 0. Se for -1, eh menor, se for
      // 0 eh igual e se 1 eh superior
      _toDoList.sort((a, b) {
        /*Nessa ordem, return 1 e return -1, os itens que não tem check vao
        * ficar em prioridade e os que tem check ficam em último
        * Se quiser mudar, apenas mude as variáveis de cada return para -1 e 1*/
        //Se a for true e b falso
        if (a["ok"] && !b["ok"]) {
          return 1;
        }
        //Se a for falso e b true
        else if (!a["ok"] && b["ok"]) {
          return -1;
        } else {
          return 0;
        }
      });

      _saveData();

      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Tarefas"),
        backgroundColor: Colors.blueAccent,
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.fromLTRB(17.0, 1.0, 7.0, 1.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  //O flutter não sabia quanto de espaço precisava para o
                  // textField(cresce infinitamente)
                  // Por isso que usa a classe Expanded() para expandir
                  // o máximo possível
                  child: TextField(
                    controller: _toDoController,
                    decoration: InputDecoration(
                        labelText: "Nova Tarefa",
                        labelStyle: TextStyle(color: Colors.blueAccent)),
                  ),
                ),
                RaisedButton(
                  onPressed: _addToDo,
                  child: Text("ADD"),
                  textColor: Colors.white,
                  color: Colors.blueAccent,
                )
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refresh,
              // LastView é um widget para construir lista
              // o builder vai construir uma lista de tarefas
              // sem prejudica a perfomace, se tiver um item abaixo,
              // da tela do celular, ele não vai renderizar
              child: ListView.builder(
                  padding: EdgeInsets.only(top: 10.0),
                  itemCount: _toDoList.length,
                  itemBuilder: buildItem),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, int index) {
    //A função vai receber o contexto(descrição), e
    // o indice da lista do item e construir e retorna
    // um widget text,
    // CheckboxListTile vai ser um meio que um azuleijo
    // que vai conter o título, o valor (check ou não)
    // e receber o ícone de ok ou vazio
    return Dismissible(
      //Usa chave genérica
      key: Key(DateTime.now().millisecondsSinceEpoch.toString()),
      background: Container(
        color: Colors.red,
        //Usa align como filho para englobar o icone e alinhar
        // onde quer
        child: Align(
          //Alignment(x, y)
          //       (-1 a 1,-1 a 1)=(esquerda a direita, cima e baixo)
          alignment: Alignment(-0.9, 0.0),
          child: Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ),
      ),
      direction: DismissDirection.startToEnd,
      //direction dá direção em que o usuário vai fazer
      // para
      child: CheckboxListTile(
        title: Text(_toDoList[index]["title"]),
        value: _toDoList[index]["ok"],
        secondary: CircleAvatar(
          child: Icon(_toDoList[index]["ok"] ? Icons.check : Icons.error),
        ),
        onChanged: (c) {
          //onChanged verifica se houve mudança de estado
          // recebendo um booleano, depois disso ele atualiza
          // a tela do celular, colocando o booleano dentro
          // do ok
          setState(() {
            _toDoList[index]["ok"] = c;
            _saveData();
          });
        },
      ),
      onDismissed: (direction) {
        setState(() {
          //Vai duplicar o item
          _lastRemoved = Map.from(_toDoList[index]);
          _lastRemovedPos = index;
          //Remove o item
          _toDoList.removeAt(index);

          _saveData();

          final snack = SnackBar(
            content: Text("Tarefa \"${_lastRemoved["title"]}\" removida!"),
            action: SnackBarAction(
                label: "Desfazer",
                onPressed: () {
                  _toDoList.insert(_lastRemovedPos, _lastRemoved);
                  _saveData();
                }),
            duration: Duration(seconds: 2),
          );

          //Função vai remover a snack bar atual e add a nova
          Scaffold.of(context).removeCurrentSnackBar(); // ADICIONE ESTE COMANDO
          Scaffold.of(context).showSnackBar(snack);
        });
      },
    );
  }

  /*
*/
  Future<File> _getFile() async {
    /*A função tem o pegar um arquivo*/

    // A função getApplicationDocumentsDirectory não é instântanea
    // Então, o programa espera aloca o caminho aonde vai armazena
    // os arquivos do diretório(vai ser do futuro). E por isso que
    // é assíncrona a função .
    // O Path Provider é importante devido o iOS e Android são SO dife-
    // rentes, assim a alocação de arquivos são diferentes
    final directory = await getApplicationDocumentsDirectory();
    // acessa o caminho do diretório e o arquivo data.json através do FIle()
    return File("${directory.path}/data.json");
  }

  Future<File> _saveData() async {
    /*A função tem o intuito de salvar os dados no arquivo*/

    //Demora para salva, por isso que é assíncrona
    //vai transforma o conteúdo da lista em json
    String data = json.encode(_toDoList);
    // cria uma variável file para receber o arquivo
    final file = await _getFile();
    // escreve o texto como string no arquivo
    return file.writeAsString(data);
  }

  Future<String> _readData() async {
    /*A função tem o intuito de ler os dados do arquivo
    * Por isso que o tipo do Map é String */
    try {
      final file = await _getFile();
      return file.readAsString();
    } catch (e) {
      return null;
    }
  }
}
