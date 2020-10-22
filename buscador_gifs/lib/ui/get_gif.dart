import 'package:flutter/material.dart';
import 'package:share/share.dart';

class GifPage extends StatelessWidget {

  //O usuário vai passar o índice do gif para ser acessado. O tipo map vai
  //possibilita esse acesso
  final Map _gifData;
  //Construtor para _gifData
  GifPage(this._gifData);

  /*Quando o usuário clickar no gif, vai abrir essa página que vai ser uma pági-
  na estática*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"]),
        backgroundColor: Colors.black,
        actions: <Widget>[
          //Cria um ícone para compartilhar o gif
          IconButton(
              icon: Icon(Icons.share),
              //Quando for pressionado o botão vai compartilha
              onPressed: () {
                  Share.share(_gifData["images"]["fixed_height"]["url"]);
              }
              ),
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        //image.network vai mostra uma imagem da internet(gif)
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
