import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lojavirtual/datas/product_data.dart';

class CartProduct {
  /*Representa os dados no carrinho de compra*/

  //representa o id do cart
  String cid;

  String category;
  String pid;

  int quantity;
  //Tamanho do produto na tela
  String size;

  //Vai acessar o produto pelo dados do carrinho
  ProductData productData;

  CartProduct();

  CartProduct.fromDocument(DocumentSnapshot document) {
    //Vai tirar uma foto do estado e coloca-la em documento do proprio estado e
    //vai armazena os valores seguintes
    cid = document.documentID;
    category = document.data["category"];
    pid = document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }

  Map<String, dynamic> toMap() {
    //passa para o bd firebase
    return {
      "category" : category,
      "pid" : pid,
      "quantity" : quantity,
      "size" : size,
      //o product eh usado para colocar informacoes do produto na ordem
      // sem se preocupa se houve mudanca de preco ou o produto nao existe mais
      "product" : productData.toResumeMap(),

    };
  }


}