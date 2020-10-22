import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CartPrice extends StatelessWidget {
  /*Essa classe representa o cartao de desconto e valor final*/

  //Recebe essa funcao para poder ser usada no cart_screen
  final VoidCallback buy;

  CartPrice(this.buy);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CartModel>(
            builder: (context, child, model) {
              double price = model.getProductsPrice();
              double discount = model.getDiscount();
              double ship = model.getShipPrice();
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    "Resumo do Pedido",
                    textAlign: TextAlign.start,
                    style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 12.0,),
                  Row(
                    //Alinha os widgets dentro do children a ter espacos entre eles
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Subtotal"),
                      Text("R\$ ${price.toStringAsFixed(2)}"),

                    ],
                  ),
                  Divider(),
                  Row(
                    //Alinha os widgets dentro do children a ter espacos entre eles
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Desconto"),
                      Text(discount == 0.0 ? "R\$ ${discount.toStringAsFixed(2)}"
                          : "R\$ -${discount.toStringAsFixed(2)}"),
                    ],
                  ),
                  Divider(),
                  Row(
                    //Alinha os widgets dentro do children a ter espacos entre eles
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Entrega"),
                      Text("R\$ ${ship.toStringAsFixed(2)}"),

                    ],
                  ),
                  Divider(),
                  SizedBox(height: 12.0,),
                  Row(
                    //Alinha os widgets dentro do children a ter espacos entre eles
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("Total",
                          style: TextStyle(fontWeight: FontWeight.w500),),
                      Text("R\$ ${(price+ship-discount).toStringAsFixed(2)}",
                          style: TextStyle(
                              color: Theme.of(context).primaryColor,
                              fontSize:16.0)
                      ),
                    ],
                  ),
                  SizedBox(height: 12.0,),
                  RaisedButton(
                      child: Text("Finalizar Produto"),
                      textColor: Colors.white,
                      color: Theme.of(context).primaryColor,
                      onPressed: buy,
                  )
                ],
              );
            }
        ),
      ),
    );
  }
}
