import 'package:cloud_firestore/cloud_firestore.dart';

class ProductData {
  /*A importancia desse arquivo eh para apenas armazena os dados do produto*/

  String category;
  String id;

  String title;
  String description;

  double price;

  List images;
  List sizes;

  //Construtor para a classe Product
  ProductData.fromDocument(DocumentSnapshot snapshot) {
    id = snapshot.documentID;
    title = snapshot.data["title"];
    description = snapshot.data["description"];
    price = snapshot.data["price"];
    images = snapshot.data["images"];
    sizes = snapshot.data["sizes"];
  }

  Map<String, dynamic> toResumeMap() {
    //resumo do carrinho atual, a quantidade de itens
    return {
      "title" : title,
      "description" : description,
      "price" : price,
    };
  }
}