import 'dart:io';

import 'package:com/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ContactPage extends StatefulWidget {

  //Cria uma instancia de contato
  final Contact contact;
  //Construtor para editar um contato
  //Por isso que opcional essa opção
  ContactPage({this.contact});


  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {

  //Variáveis para pegar as informações mudadas
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  //Variável para focar no campo que está faltando informação
  final _nameFocus = FocusNode();

  //Variável para verificar se o usuário mudou alguma informação
  bool _userEdited = false;

  Contact _editedContact;

  @override
  void initState() {
      super.initState();
      //Para acessar o contact da classe ContactPage(classe diferentes)
      //Usa widget. pois o widget representa o objeto contactpage
      // e contact eh o atributo
      if(widget.contact == null) {
        //Caso não tenha contato para editar,cria um novo contato
        _editedContact = Contact();
      }
      else {
        //Se tiver um contato,recebe as informações do contato e transforma em
        // um mapa no bd
        _editedContact = Contact.fromMap(widget.contact.toMap());

        //Atribui os dados já preenchidos do usuário e coloca no formulário
        _nameController.text = _editedContact.name;
        _emailController.text = _editedContact.email;
        _phoneController.text = _editedContact.phone;
      }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _requestPop,
        child:  Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            title: Text(_editedContact.name ?? "Novo Contato"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(_editedContact.name != null && _editedContact.name.isNotEmpty) {
                /*O método pop vai remover a tela atual e volta para tela anterior
              O navigator funciona como uma estrutura de
              pilha(homepage,contactpage) , por isso que quando da pop, volta
              para página anterior */
                //Através do método pop, dá para passar variáveis dessa página á
                // anterior
                Navigator.pop(context, _editedContact);
              }
              else {
                FocusScope.of(context).requestFocus(_nameFocus);
              }
            },
            child: Icon(Icons.save),
            backgroundColor: Colors.red,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    width: 140.0,
                    height: 140.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: _editedContact.img != null ?
                          FileImage(File(_editedContact.img)):
                          AssetImage("images/person.jpg")
                      ),
                    ),
                  ),
                  onTap: () {
                    ImagePicker.pickImage(source: ImageSource.camera).then(
                            (file) {
                              if(file == null)
                                return;
                              setState(() {
                                _editedContact.img = file.path;
                              });
                    }
                    );
                  },
                ),
                TextField(
                  controller: _nameController,
                  focusNode: _nameFocus,
                  //A decoração esticou a imagem ao centro
                  decoration: InputDecoration(
                      labelText: "Nome"),
                  onChanged: (text) {
                    _userEdited = true;
                    setState(() {
                      _editedContact.name = text;
                    });
                  },
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      labelText: "Email"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.email = text;
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                TextField(
                  controller: _phoneController,
                  decoration: InputDecoration(
                      labelText: "Phone"),
                  onChanged: (text) {
                    _userEdited = true;
                    _editedContact.phone = text;
                  },
                  keyboardType: TextInputType.phone,
                ),
              ],
            ),
          ),
        ),
    );
  }
  
  Future<bool> _requestPop() {
    if(_userEdited) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Descartar as Alterações?"),
            content: Text("Se sair as alterações serão perdidas."),
            actions: <Widget>[
              FlatButton(
                  child: Text("Cancelar"),
                  onPressed: () {
                    //Saída manual da tela
                    //Volta apenas para página de contactPage
                    Navigator.pop(context);
                  },
              ),
              FlatButton(
                  child: Text("Sim"),
                  onPressed: () {
                    //Saída manual da tela
                    //Volta apenas para página de contactPage
                    Navigator.pop(context);
                    //Volta apenas para página de homePage
                    Navigator.pop(context);
                  },
              ),
            ],
          );
        }
      );
      //desabilita o usuario de sair automaticamente da tela
      return Future.value(false);
    }
    else {
      //permite o usuario de sair automaticamente da tela
      return Future.value(true);
    }
  }

}
