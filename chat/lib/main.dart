import 'package:chat/ui/chat_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {

  runApp(MyApp());

  //instance = singleton para o bd do firebase, acessa a coleção,documento
  // e depois coloca qualquer tipo de dado com o valor
  //atualiza em tempo real
  //quando você retira o id do documento , o firebase cria um id próprio
  /*Firestore.instance.collection("col").document("msg1").updateData(
      {"texto":"verdade",
      "boolean":true,
      "read":2,
      });*/
  //le o dado , depois fecha
  //obter atualizacoes de modificacao
  //QuerySnapshot é um tipo de classe para vários documentos
  //DocumentSnapshot eh apenas para 1 documento
  /*QuerySnapshot snapshot = await Firestore.instance.collection("col").getDocuments();
  //print(snapshot.data);
  snapshot.documents.forEach((d) {
    d.reference.updateData({"lido":false});
  });*/
  /*Firestore.instance.collection("col").document("msg1").snapshots().listen((data) {
    print(data.data);
  });*/
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Flutter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        //Muda todas as cores do icone em zual do app, ou quando esta ativo
        iconTheme: IconThemeData(
          color : Colors.blue,
        ),
      ),
      home: chatScreen(),
    );
  }
}