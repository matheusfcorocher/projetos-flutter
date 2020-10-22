import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(home: Home()));
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // O mapa glogalkey sempre eh usado para formulários, preenchimento de dados,
  // etc...
  //TextFormField a diferença entre ele e TextField e que ele tem o campo validate
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();
  String _info = "Informe os seus dados";

  void _resetFields() {
    //Os controladores não precisam se redesenhar devido deles serem propriamen-
    //te redesenhados na classe build, enquanto o _info, precisa chamar um set
    //state para ser redesenhado
    weightController.text = "";
    heightController.text = "";
    setState(() {
      _info = "Informe os seus dados";
    });
  }

  void _calculate() {
    setState(() {
      double weight = double.parse(weightController.text);
      // divide por 100, devido esta em cm, a altura
      double height = double.parse(heightController.text) / 100;
      double imc = weight / (height * height);
      print(imc);
      if (imc < 18.6) {
        _info = "Abaixo do Peso (${imc.toStringAsPrecision(3)})";
      } else if (imc > 18.6 && imc <= 24.9) {
        _info = "Peso Ideal (${imc.toStringAsPrecision(3)})";
      } else if (imc > 24.9 && imc <= 29.9) {
        _info = "Levemente Acima do Peso (${imc.toStringAsPrecision(3)})";
      } else if (imc > 29.9 && imc <= 34.9) {
        _info = "Obesidade Grau I (${imc.toStringAsPrecision(3)})";
      } else if (imc > 34.9 && imc <= 39.9) {
        _info = "Obesidade Grau II (${imc.toStringAsPrecision(3)})";
      } else if (imc > 40) {
        _info = "Obesidade Grau III (${imc.toStringAsPrecision(3)})";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculadora IMC", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.amberAccent,
        actions: <Widget>[
          IconButton(icon: Icon(Icons.refresh), onPressed: _resetFields),
        ],
      ),
      backgroundColor: Colors.white,
      // Usa o botão da coluna, pois o sketch do app, mostra que está tudo alinha-
      // do os componentes
      // SingleChildScrollView permite a rolagem da tela se precisa,exemplo: se
      // um componente for muito grande, ela automaticamente rola, e você conse-
      // gue olhar para toda info que está no app, além disso, ela apenas aceita
      // um filho(singleChild)
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: Form(
          key: _formKey,
          child: Column(
            //O cruzamento do eixo vertical com o eixo horizontal da imagem, usou o
            // alinhamento do tipo strech(ocupa do espaço disponível entre o cruza-
            // mento dos eixos, Isso também vai aplicar para o botão de peso, altura,
            // todos que tiverem na coluna )
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              //O icone é a imagem da pessoa
              Icon(Icons.person_outline,
                  size: 120.0, color: Colors.amberAccent),
              //Campo de preenchimento de da altura e do peso
              //Vai apenas aceita o tipo inteiro, decoração será colocado o campo in
              //putdecoration, alinhamento do centro
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Peso(kg)",
                    labelStyle: TextStyle(color: Colors.amberAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amberAccent, fontSize: 25.0),
                controller: weightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira seu Peso!!";
                  }
                },
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "Altura(cm)",
                    labelStyle: TextStyle(color: Colors.amberAccent)),
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amberAccent, fontSize: 25.0),
                controller: heightController,
                validator: (value) {
                  if (value.isEmpty) {
                    return "Insira sua Altura!!";
                  }
                },
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Container(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        _calculate();
                      }
                    },
                    child: Text("Calcular",
                        style: TextStyle(color: Colors.white, fontSize: 25.0)),
                    color: Colors.amberAccent,
                  ),
                ),
              ),
              Text(
                _info,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.amberAccent, fontSize: 25.0),
              )
            ],
          ),
        ),
      ),
    );
  }
}
