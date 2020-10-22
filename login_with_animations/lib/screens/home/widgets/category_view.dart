import 'package:flutter/material.dart';

class CategoryView extends StatefulWidget {
  @override
  _CategoryViewState createState() => _CategoryViewState();
}

class _CategoryViewState extends State<CategoryView> {

  final List<String> categories = [
    "trabalho",
    "estudos",
    "casa",
  ];

  int _category = 0;//indice representando qual categoria esta

  void selectForward() {
    setState(() {
      _category++;
    });
  }

  void selectBackward() {
    setState(() {
      _category--;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        IconButton(
            icon: Icon(Icons.arrow_back_ios),
            color: Colors.white,
            disabledColor: Colors.white30,
            onPressed: _category > 0 ? selectBackward : null,
        ),
        Text(
            categories[_category].toUpperCase(),
          style: TextStyle(
            fontSize: 18,
            letterSpacing: 1.2,
            fontWeight: FontWeight.w300,
            color: Colors.white
          ),
        ),
        IconButton(
          icon: Icon(Icons.arrow_forward_ios),
          color: Colors.white,
          //Aparencia do botao quando esta desabilitado
          disabledColor: Colors.white30,
          //Se ultrapassa o tamanho da lista, desabilita o botao
          onPressed: _category < categories.length - 1 ? selectForward : null,
        ),
      ],
    );
  }
}
