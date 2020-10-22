import 'package:flutter/material.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/home_screen.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:scoped_model/scoped_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //Vai devolver um ScopedModel, devido a pasta models
    return ScopedModel<UserModel>(
      //O child vai pode acessar o modelo UserModel e vice-versa,
      // podendo alterar
        model: UserModel(),
        //Cada vez que muda de usuario ira refazer a tela
        //do carrinho
        //Precisa especifica o tipo de modelo do ScopedModel
        //senao da erro
        child: ScopedModelDescendant<UserModel>(
            builder: (context, child, model) {
              return ScopedModel<CartModel>(
                //model representa o usuario
                  model: CartModel(model),
                  child: MaterialApp(
                    title: 'Flutters Clothing',
                    theme: ThemeData(
                      primarySwatch: Colors.blue,
                      primaryColor: Color.fromARGB(255, 4, 125, 141),
                    ),
                    debugShowCheckedModeBanner: false,
                    home: HomeScreen(),
                  )
              );
            }
        )
    );
  }
}
