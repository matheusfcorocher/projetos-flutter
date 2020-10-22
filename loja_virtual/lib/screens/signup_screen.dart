import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';


class SignUpScreen extends StatefulWidget {
  //
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  /*Essa classe mostra a tela de cadastro*/

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _addressController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Criar Conta"),
        centerTitle: true,
      ),
      //Coloca um formulario para preencher dados
      body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if(model.isLoading)
              return Center(child:CircularProgressIndicator(),);
            return Form(
              key: _formKey,
              //coloca na vista de lista
              child: ListView(
                padding: EdgeInsets.all(16.0),
                children: <Widget>[
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Nome Completo",
                    ),
                    validator: (text) {
                      if(text.isEmpty)
                        return "Nome inválido";
                    },
                  ),
                  //Espaco entre nome e e-mail
                  SizedBox(height: 16.0,),
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
                  SizedBox(height: 16.0,),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Endereço",
                    ),
                    validator: (text) {
                      if(text.isEmpty || text.length<6)
                        return "Endereço inválido";
                    },
                  ),
                  SizedBox(height: 16.0,),
                  //Usa um SizedBox para aumentar o tamanho do botao
                  SizedBox(
                    height: 44.0,
                    child: RaisedButton(
                      onPressed: () {
                        if(_formKey.currentState.validate()) {

                          //Nao passa a senha do usuario
                          Map<String, dynamic> userData = {
                            "name": _nameController.text,
                            "email": _emailController.text,
                            "address": _addressController.text,
                          };

                          //chama a funcao signUp se tiver sucesso ele muda para tela de signup
                          model.signUp(
                              userData: userData,
                              pass: _passController.text,
                              onSucess: _onSucess,
                              onFail: _onFail
                          );

                        }
                      },
                      child: Text(
                        "Criar Conta",
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
          }
      ),
    );
  }

  void _onSucess() {
    /*Mostra uma barra de sucesso se o usuario foi criado e fecha a pagina de criacao*/
    //Um jeito de acessar o Scaffold seria Scaffold.of(context), porem a
    // maneira certa eh usar a key para acessar o Scaffold atual
    _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text("Usuário criado com sucesso"),
            backgroundColor: Theme.of(context).primaryColor,
            duration: Duration(seconds: 2),
        ),
    );

    //Sai da tela de criação de conta
    Future.delayed(Duration(seconds: 2)).then((_) {
      Navigator.of(context).pop();
    }
    );
    
  }

  void _onFail() {
    /*Mostra uma barra de fala se o usuario nao conseguiu ser criado*/
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text("Falha ao criar o usuário"),
        backgroundColor: Theme.of(context).primaryColor,
        duration: Duration(seconds: 2),
      ),
    );

  }
}
