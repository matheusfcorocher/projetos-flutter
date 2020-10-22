import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/tiles/product_tile.dart';

class CategoryScreen extends StatelessWidget {
  /*Essa tela tem o objetivo de mostar a tela em 2 formas: tabela ou em série*/
  
  final DocumentSnapshot snapshot;

  //Ele vai receber o documento snapshot(foto rápida) para construir a tela pedida
  CategoryScreen(this.snapshot);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        //App Bar representa o componente que fica no topo(recurso do Scaffold)
        appBar: AppBar(
          title: Text(snapshot.data["title"],),
          centerTitle: true,
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: <Widget>[
              //Tab com icone de tabela
              Tab(icon: Icon(Icons.grid_on),),
              //Tab com icone de lista
              Tab(icon: Icon(Icons.list),),
            ],
          ),
        ),
       //Corpo do Scaffold
       body: FutureBuilder<QuerySnapshot>(
         //Quando voce coloca o tipo do futuroBuilder <tipo>, facilita o depurador
         // de encontrar erros, DocumentSnapshot eh uma fotografia de um documento e
         // QuerySnapshot eh fotografia de uma colecao
         future: Firestore.instance.collection("products").
         document(snapshot.documentID).collection("itens").getDocuments(),
         builder: (context, snapshot) {
             if(!snapshot.hasData)
               return Center(child: CircularProgressIndicator(),);
             else
               return TabBarView(
                 //para que o usuario não arraste a tela para o lado quando estiver percorrendo a lista
                   physics: NeverScrollableScrollPhysics(),
                   children: [
                     //GridView.build eh usado pois eh carregado um item de cada vez, nao carrega tudo
                     GridView.builder(
                       padding: EdgeInsets.all(4.0),
                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                         //O formato cross depende da main, se a main eh vertical
                         // o cross eh horizontal, se main for horizontal entao cross
                         // eh vertical
                         //Quantidade de itens
                         crossAxisCount: 2,
                         //espaco do eixo principal
                         mainAxisSpacing: 4.0,
                         //espaco no eixo cruzado
                         crossAxisSpacing: 4.0,
                         //aspectRatio eh a razao da largura/altura
                         childAspectRatio: 0.65,
                       ),
                       itemCount: snapshot.data.documents.length,
                       itemBuilder: (context, index) {
                         ProductData data = ProductData.fromDocument(snapshot.
                         data.documents[index]);
                         //Usa o ProductData eh para modularizar o codigo, se for troca
                         // as informações para outro bd
                         //usa this.snapshot pois esta dentro do documento
                         data.category = this.snapshot.documentID;
                         return ProductTile("grid", data);
                       },
                     ),
                     ListView.builder(
                         padding: EdgeInsets.all(4.0),
                         itemCount: snapshot.data.documents.length,
                         itemBuilder: (context, index) {
                           ProductData data = ProductData.fromDocument(snapshot.
                           data.documents[index]);
                           //Usa o ProductData eh para modularizar o codigo, se for troca
                           // as informações para outro bd
                           data.category = this.snapshot.documentID;
                           return ProductTile("list", data);
                         }
                     ),
                   ]
               );
           },
       ),
      ),

    );
  }
}

    