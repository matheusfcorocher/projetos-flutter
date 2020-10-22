import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
/*Representa um cartao de um produto para o carrinho*/
class CartTile extends StatelessWidget {

  final CartProduct cartProduct;

  CartTile(this.cartProduct);

  @override
  Widget build(BuildContext context) {

    Widget _buildContent() {
        CartModel.of(context).updatePrices();

        //Conteudo do cartao
        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0.0),
              width: 120.0,
              child: Image.network(
                  cartProduct.productData.images[0],
                  fit: BoxFit.cover,
              ),
            ),
            Expanded(
                child: Container(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        cartProduct.productData.title,
                        style: TextStyle(fontWeight: FontWeight.w500,
                            fontSize: 17.0),
                      ),
                      Text(
                        "Tamanho:${cartProduct.size}",
                        style: TextStyle(fontWeight: FontWeight.w300,),
                      ),
                      Text(
                        "R\$ ${cartProduct.productData.price.toStringAsFixed(2)}",
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        //dar um espaco do remover e + -
                        //quando usa null onPressed, desabilitao botao
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          IconButton(
                              icon: Icon(Icons.remove),
                              color: Theme.of(context).primaryColor,
                              onPressed: cartProduct.quantity > 1 ?
                              () {
                                CartModel.of(context).decProduct(cartProduct);
                              } : null,
                          ),
                          Text(
                            cartProduct.quantity.toString(),
                          ),
                          IconButton(
                            icon: Icon(Icons.add),
                            color: Theme.of(context).primaryColor,
                            onPressed: () {
                              CartModel.of(context).incProduct(cartProduct);
                            },
                          ),
                          FlatButton(
                            child: Text("Remover"),
                            textColor: Colors.grey[500],
                            onPressed: () {
                              CartModel.of(context).removeCartItem(cartProduct);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            )
          ],
        );
    }

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: cartProduct.productData == null ?
            FutureBuilder<DocumentSnapshot>(
                future: Firestore.instance.collection("products").
                document(cartProduct.category).collection("itens").
                document(cartProduct.pid).get(),
                builder: (context, snapshot) {
                  if(snapshot.hasData) {
                    //Se tiver dados ele vai pega os dados e transforma em tile
                    cartProduct.productData = ProductData.fromDocument(snapshot.data);
                    return _buildContent();
                  }
                  else {
                    return Container(
                      height: 70.0,
                      child: CircularProgressIndicator(),
                      alignment: Alignment.center,
                    );
                  }
                },
            ) :
            //Ja tem os dados, ja constroi o tile cart
            _buildContent()
    );
  }
}
