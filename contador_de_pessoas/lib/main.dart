import 'dart:async';

import 'package:flutter/material.dart';

void main() {
  /*Chama uma função do package chamado runApp
   A função MaterialApp é um Widget que vai receber parâmetros title e home. O parâmetro home recebe outro Widget com parâmetro da cor
   O title não é o título do aplicativo quando mostra, ele apenas descrição interna do app*/
  runApp(
      MaterialApp(title: "Contador de Pessoas", home: Home())); // Material App
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _people = 0;
  String _textInfo = "Pode entrar!!";

  final StreamController<int> _streamController = StreamController<int>();


  @override
  void dispose() {
    _streamController.close();
    super.dispose();
  }

  void _incrementPeople() {
    _people++;
    _streamController.sink.add(_people);
  }

  void _decrementPeople() {
    _people--;
    _streamController.sink.add(_people);
  }

  /*void changedPeople(int delta) {
    //Essa função recebe um aumento ou decremento depois de apertado o botão e depois atualiza as variáveis e suas mensagens
    //setState serve para atualizar a mudança de variáveis que ocorre dentro do build
    setState(() {
      _people += delta;
      if (_people < 0) {
        _textInfo = "Mundo Invertido!";
      } else if (_people <= 10) {
        _textInfo = "Pode entrar!!";
      } else {
        _textInfo = "Está lotado, espera um momento.";
      }
    });
  }*/

  @override
  // a função build sempre alguma coisa que muda o layout
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Image.asset(
          "images/restaurant.jpg",
          fit: BoxFit.cover,
          height: 1000.0,
        ),
        Column(
          //a função mainAxis vai alinhar a coluna(Widget) ao meio do celular
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<int>(
              stream: _streamController.stream,
              initialData: 0,
              builder: (BuildContext context, AsyncSnapshot<int> snapshot) {
                return Text("Pessoas : ${snapshot.data}",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold));
              },
            ),
            Row(
              //O eixo principal aqui é a linha
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                      onPressed: () {
                        _incrementPeople();
                      },
                      child: Text(
                        "+1",
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      )),
                ),
                Padding(
                  padding: EdgeInsets.all(10.0),
                  child: FlatButton(
                      onPressed: () {
                        _decrementPeople();
                      },
                      child: Text(
                        "-1",
                        style: TextStyle(fontSize: 40.0, color: Colors.white),
                      )),
                ),
              ],
            ),
            Text(_textInfo,
                style: TextStyle(
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                    fontSize: 30.0)),
          ],
        ),
      ],
    );
  }
}
