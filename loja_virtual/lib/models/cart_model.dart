import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartModel extends Model {

  UserModel user;

  List<CartProduct> products = [];

  String couponCode;
  int discountPercentage = 0;

  bool isLoading = false;

  //Muda o carrinho dependendo do usuario
  CartModel(this.user) {
    if(user.isLoggedIn())
      _loadCartItems();
  }

  static CartModel of(BuildContext context) =>
      ScopedModel.of<CartModel>(context);

  void addCartItem(CartProduct cartProduct) {
    products.add(cartProduct);

    Firestore.instance.collection("users").document(user.firebaseUser.uid)
    .collection("cart").add(cartProduct.toMap()).then((doc) {
      //Depois de adicionar o carrinho no firebase, ele pega o id do carrinho
      //o qual id sera gerado pelo proprio firebase e adicionar no bd
      cartProduct.cid = doc.documentID;
    });

    //notifica os listeners
    notifyListeners();
  }

  void removeCartItem(CartProduct cartProduct) {
    //remove do firestore
    Firestore.instance.collection("users").document(user.firebaseUser.uid)
        .collection("cart").document(cartProduct.cid).delete();

    //remove do bd
    products.remove(cartProduct);

    notifyListeners();
  }

  void decProduct(CartProduct cartProduct) {
    //diminui a quantidade do produto na tela de carrinho
    cartProduct.quantity--;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void incProduct(CartProduct cartProduct) {
    //aumenta a quantidade do produto na tela de carrinho
    cartProduct.quantity++;

    Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("cart").document(cartProduct.cid).updateData(cartProduct.toMap());

    notifyListeners();
  }

  void setCoupon(String couponCode, int discountPercentage) {
    //Aplica o coupom recebido
    this.couponCode = couponCode;
    this.discountPercentage = discountPercentage;
  }

  void updatePrices() {
    //notifica os widgets de que mudaram, util para atualizar o preco
    notifyListeners();
  }

  double getProductsPrice() {
    //Pega os valores dos produtos do carrinho
    double price = 0.0;
    for(CartProduct c in products) {
      //Usa c.productData!= null para dizer que foi carregado o valor do produto
      if(c.productData != null)
        price += c.quantity * c.productData.price;
    }
    return price;

  }

  double getDiscount() {
    //Retorna o desconto do preco
    return getProductsPrice() * discountPercentage / 100;
  }

  double getShipPrice() {
    //Retorna o valor do frete
    return 9.99;
  }

  Future<String> finishOrder() async {
    //Finaliza o pedido do usuario
    if(products.length == 0)
      return null;

    //Chama a tela de loading
    isLoading = true;
    notifyListeners();

    double productsPrice = getProductsPrice();
    double shipPrice = getShipPrice();
    double discount = getDiscount();
    //Salva o id do documento na variavel refOrder
    DocumentReference refOrder = await Firestore.instance.collection("orders").add(
        {
          "clientId" : user.firebaseUser.uid,
          //Armazena sempre em mapa pois o firebase funciona com mapa e nao lista
          "products" : products.map((cartProduct) => cartProduct.toMap()).toList(),
          "shipPrice" : shipPrice,
          "productsPrice" : productsPrice,
          "discount" : discount,
          "totalPrice" : productsPrice - discount + shipPrice,
          //status indica qual estagio da compra o usuario esta(1 ate 4)
          "status" : 1
        }
    );
    
    await Firestore.instance.collection("users").document(user.firebaseUser.uid).
    collection("orders").document(refOrder.documentID).setData(
        {
          //coloca o ID na colecao order no firebase
          "orderID" : refOrder.documentID,
        }
    );

    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.firebaseUser.uid).collection("cart").getDocuments();

    for(DocumentSnapshot doc in query.documents) {
      //Deleta cada item do carrinho do usuario
      doc.reference.delete();
    }

    products.clear();

    couponCode = null;
    discountPercentage = 0;

    isLoading = false;
    notifyListeners();

    //retorna o documento da compra para mostra ao usuario
    return refOrder.documentID;
  }


  void _loadCartItems() async{
    //carrega os produtos na tela de carrinho
    QuerySnapshot query = await Firestore.instance.collection("users").
    document(user.firebaseUser.uid).collection("cart").getDocuments();


    products = query.documents.map((doc) => CartProduct.fromDocument(doc)).
    toList();

    notifyListeners();
  }
}