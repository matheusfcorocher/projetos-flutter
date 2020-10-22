import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/tiles/category_tile.dart';

/*Representa o conteudo da Tab Produtos*/

class ProductsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("products").getDocuments(),
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Center(child: CircularProgressIndicator(),);
          else {

            var dividedTiles = ListTile.divideTiles(tiles: snapshot.data.documents.map(
                    (doc) {
                  //transforma o documento em categoryTile
                  // e depois devolve em uma lista
                  return CategoryTile(doc);
                }
            ).toList(),
              //devolve um separador de cor cinza em formato de lista
              color: Colors.grey[500]).toList();

            return ListView(
              children: dividedTiles
            );
          }
        },
    );
  }
}
