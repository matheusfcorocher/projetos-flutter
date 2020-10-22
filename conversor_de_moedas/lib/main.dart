import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?key=832b87a9";

void main () async{

  runApp(MaterialApp(
        title: "Conversor de Moedas",
        home: Home(),
        //Usa theme para mostrar a cor do R$ quando for coloca um texto e
        // primary color para a caixa de input fique visível
    theme: ThemeData(
        hintColor: Colors.amber,
        primaryColor: Colors.white,
        inputDecorationTheme: InputDecorationTheme(
          enabledBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
          OutlineInputBorder(borderSide: BorderSide(color: Colors.amber)),
          hintStyle: TextStyle(color: Colors.amber),
        )),
  ));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  double dolar;
  double euro;

  void _clearAll() {
    //tem a função de apagar todos os textos
    realController.text = "";
    dolarController.text = "";
    euroController.text = "";
  }

  void _realChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      //O return serve pra garantir que a função não vai continuar, ou seja,
      // ele nem vai calcular os valores da conversão. Recomendo que mantenha o
      // return pois ele é uma garantia que não vai ocorrer um erro já que o
      // campo é vazio.
      return;
    }
    double real = double.parse(text);
    dolarController.text = (real/dolar).toStringAsFixed(2);
    euroController.text = (real/euro).toStringAsFixed(2);
  }
  void _dolarChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double dolar = double.parse(text);
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar/euro).toStringAsFixed(2);
  }
  void _euroChanged(String text) {
    if(text.isEmpty) {
      _clearAll();
      return;
    }
    double euro = double.parse(text);
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro/dolar).toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("\$ Conversor de Moedas \$"),
        centerTitle: true,
        backgroundColor: Colors.amber,
      ),
      body: FutureBuilder<Map>(
          // Usa o <Map> no FutureBuilder,pois getData() é um mapa
          //a variável future, já da classe FutureBuilder vai receber info do
          //getData
          future: getData(),
          //variavel snapshot é meio que uma foto do estado anterior da url
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting :
                return Center(
                    child: Text("Carregando Dados...",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.amber,
                          fontSize: 25.0),
                    )
                );
              default :
                if (snapshot.hasError) {
                  //A classe Center centraliza tudo
                  return Center(
                      child: Text("Erro ao Carregar Dados...",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.amber,
                            fontSize: 25.0),
                      )
                  );
                }
                else {
                  dolar = snapshot.data["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                          Icon(Icons.monetization_on, size: 150.0, color: Colors.amber,),
                        buildTextField("Reais", "R\$", realController, _realChanged),
                        //Usa o Divider() para que os textos não invadem as bordas
                        //da caixa de texto de cima
                        Divider(),
                        buildTextField("Doláres", "U\$", dolarController, _dolarChanged),
                        Divider(),
                        buildTextField("Euros", "€", euroController, _euroChanged),
                    ],),
                  );
                }
            }
          }
    )
    );
  }
}

Widget buildTextField(String label, String prefix, TextEditingController c, Function f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.amber),
      border: OutlineInputBorder(),
      prefixText: prefix,
    ),
    style: TextStyle(
      color: Colors.amber, fontSize: 25.0,
    ),
    onChanged: f,
    //Altera o teclado para digitação apenas números
    keyboardType: TextInputType.number,
  );

}


Future<Map> getData() async{
  /*Essa função vai criar um variável response que vai ser do tipo
  http.Response(classe), a qual vai receber await(função para esperar e pega a
  api requisitada). Depois disso, ela retornará decodificação dessa API no forma-
  to JSON e retornará o próprio JSON e não instância. A função getData() trans-
  formará o formato JSON em um mapa no formato dart. Future(é um tipo de classe
  da API do dart:async*/
  http.Response response = await http.get(request);
  //usa response.body para chamar o corpo do JSON,não a sua instância e jsondecode
  // é uma função da API dart:convert
  return jsonDecode(response.body);
}