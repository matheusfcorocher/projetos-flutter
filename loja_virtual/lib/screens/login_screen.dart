import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/signup_screen.dart';
import 'package:scoped_model/scoped_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  /*Essa classe mostra a tela de login*/

  final _emailController = TextEditingController();
  final _passController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          //botoes que vai ficar na app bar
          actions: <Widget>[
            FlatButton(
              onPressed: () {
                //push -> vai mandar para a tela
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => SignUpScreen())
                );
              },
              child: Text(
                "CRIAR CONTA",
                style: TextStyle(
                  fontSize: 15.0,

                ),
              ),
              textColor: Colors.white,
            ),
          ],
        ),
        //ScopedModelDescendant eh usado para acessar o modelo usuario
        //Se for modificado o user model, todo formulario vai ser reconstruido
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if(model.isLoading)
              return Center(child: CircularProgressIndicator(),);
            //Coloca um formulario para preencher dados
            return Form(
              key: _formKey,
              //coloca na vista de lista
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "E-mail",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (text) {
                      if(text.isEmpty || !text.contains("@"))
                        return "E-mail inválido";
                    },
                  ),
                  //Espaco entre e-mail e senha
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _passController,
                    decoration: InputDecoration(
                      hintText: "Senha",
                    ),
                    obscureText: true,
                    validator: (text) {
                      if(text.isEmpty || text.length<6)
                        return "Senha inválida";
                    },
                  ),
                  //Coloca o outro texto abaixo de senha
                  Align(
                    alignment: Alignment.centerRight,
                    child: FlatButton(
                      onPressed: () {
                        if(_emailController.text.isEmpty) {
                          /*Mostra uma barra de aviso*/
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Insira seu e-mail para recuperação"),
                              backgroundColor: Colors.redAccent,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                        else {
                          model.recoverPass(_emailController.text);
                          /*Mostra uma barra de fala se o usuario nao conseguiu ser criado*/
                          _scaffoldKey.currentState.showSnackBar(
                            SnackBar(
                              content: Text("Confira seu e-mail"),
                              backgroundColor: Theme.of(context).primaryColor,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      },
                      child: Text(
                        "Esqueci minha senha",
                        textAlign: TextAlign.right,
                      ),
                      //Retira o padding
                      padding: EdgeInsets.zero,
                    ),
                  ),
                  SizedBox(height: 16.0,),
                  //Usa um SizedBox para aumentar o tamanho do botao
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {


                        }
                        model.signIn(
                          email: _emailController.text,
                          pass: _passController.text,
                          onSucess: _onSucess,
                          onFail: _onFail,

                        );
                      },
                      child: Text(
                        "Entrar",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            );
          },
        )
    );
  }

  void _onSucess() {
      Navigator.of(context).pop();
  }

  void _onFail() {
    /*Mostra uma barra de fala se o usuario nao conseguiu ser criado*/
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao emtrar no usuário"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );
  }

}
