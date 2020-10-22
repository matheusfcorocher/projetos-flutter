import 'dart:io';

import 'package:chat/ui/text_composer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../chat_message.dart';

class chatScreen extends StatefulWidget {
  @override
  _chatScreenState createState() => _chatScreenState();
}

class _chatScreenState extends State<chatScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  FirebaseUser _currentUser;
  //Serve para mostrar que esta carregando a imagem
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    //Se tiver algum usuario, ele vai mostra o usuario
    //Senao mostra vazio
    FirebaseAuth.instance.onAuthStateChanged.listen((user){
      setState(() {
        _currentUser = user;
      });
    });

  }

  Future<FirebaseUser> _getUser() async{
    //Se tiver ja logado,volta o login
    if(_currentUser != null)
      return _currentUser;

    //Loga o usuario
    try {
      //Entra o usuario com sua conta Google
      final GoogleSignInAccount = await googleSignIn.signIn();
      //Autentica o usuario
      final GoogleSignInAuthentication googleSignInAuthentication =
          await GoogleSignInAccount.authentication;

      //idtoken e acesstoken são as credenciais necessarias
      // para entrar no firebase
      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
      );
      //O resultado da autenticação, possiblita o usuario entra
      final AuthResult authResult = await FirebaseAuth.instance.signInWithCredential(credential);

      //Pega o usuario do firebase,valida o seu acesso
      final FirebaseUser user = authResult.user;
      return user;
    }
    catch (error) {
      return null;
    }
  }

  void _sendMessage({String text, File imgFile}) async{
    final FirebaseUser user = await _getUser();

    if(user == null) {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
            content: Text("Não foi possível fazer a login, Tente Novamente!"),
            backgroundColor: Colors.red,
        )
      );
    }

    //Cria um mapa da mensagem, com o nome do user,o id ,etc...
    Map<String, dynamic> data = {
      "uid" : user.uid,
      "senderName" : user.displayName,
      "senderPhotoUrl" : user.photoUrl,
      //ordena pelo tempo
      "time" : Timestamp.now(),
    };

    if (imgFile != null) {
      //Foi armazenado a foto na seçção storage e colocado o nome na instância
      // do momoento em milisegundos
      //Coloca na pasta do usuario e depois as mensagens feitas por ele
      StorageUploadTask task = FirebaseStorage.instance.ref().child("uid").child(
          DateTime.now().millisecondsSinceEpoch.toString()).putFile(imgFile);

      setState(() {
        _isLoading = true;
      });

      //taskSnapshot devolve as informações da img carregada
      StorageTaskSnapshot taskSnapshot = await task.onComplete;
      //devolve a url da imagem
      String url = await taskSnapshot.ref.getDownloadURL();
      data["imgUrl"] = url;

      setState(() {
        _isLoading = false;
      });

    }

    if(text != null) {
      data["text"] = text;
      //.add é outra forma de colocar dados em uma coleção do firebase
      Firestore.instance.collection("messages").add(data);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
            _currentUser != null ? "Olá, ${_currentUser.displayName}" : "Chat App"
        ),
        centerTitle: true,
        elevation: 0,
        actions: <Widget>[
          _currentUser != null ? IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              //Sai do firebase
              FirebaseAuth.instance.signOut();
              //Sai da conta do google
              googleSignIn.signOut();
              _scaffoldKey.currentState.showSnackBar(
                  SnackBar(
                    content: Text("Você saiu com sucesso!!"),
                    backgroundColor: Colors.red,
                  ));
            },
          ) : Container()
        ],
      ),
      body: Column(
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  //QuerySnapshot traz uma pesquisa sobre o snapshot(info)
                  //stream builder recria lista de mensagens,
                  // stream sempre retorna um dado se houver modificação
                  // snapshot -> stream
                  stream: Firestore.instance.collection("messages").orderBy("time").snapshots(),
                  builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                      case ConnectionState.none:
                      case ConnectionState.waiting:
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      default:
                        //ordena a lista na forma inversa
                        List<DocumentSnapshot> documents =
                            snapshot.data.documents.reversed.toList();

                        //Vai adicionando dados com o rolar da tela,
                        // por isso que usa ListView
                        return ListView.builder(
                            itemCount: documents.length,
                            //aparece as imagens debaixo para cima
                            reverse: true,
                            itemBuilder: (context, index) {
                              return ChatMessage(
                                  documents[index].data,
                                  documents[index].data["uid"] == _currentUser?.uid
                                  //verifica o id do usuario se for seu ou de outra pessoa
                              );
                            },
                        );
                    }
                  },
              ),
          ),
          //barra horizontal de carregamento para imagem
          _isLoading ? LinearProgressIndicator() : Container(),
          textComposer(_sendMessage),
        ],
      ),
    );
  }
}
