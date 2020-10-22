import 'package:flutter/material.dart';
import 'package:lojavirtual/screens/cart_screen.dart';

class CartButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //Esse widget representa o botao que fica na regiao baixa da tela
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => CartScreen())
          );
        },
        child: Icon(Icons.shopping_cart, color: Colors.white,),
        backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
