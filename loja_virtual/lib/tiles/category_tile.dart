import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/category_screen.dart';

/*Vai receber o documentos e vai mandar os dados para o list_tile
com os dados(categoria e icone)*/

class CategoryTile extends StatelessWidget {

  final DocumentSnapshot snapshot;

  //Construtor com o snapshot(foto do momento da cloudfirestore)
  CategoryTile(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      //leading eh o icone que fica na esquerda
      leading: CircleAvatar(
        radius: 25.0,
        backgroundColor: Colors.transparent,
        backgroundImage: NetworkImage(snapshot.data["icon"]),
      ),
      title: Text(snapshot.data["title"]),
      //icone que fica na direita
      trailing: Icon(Icons.keyboard_arrow_right),
      onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CategoryScreen(snapshot))
          );
      },
    );
  }
}
