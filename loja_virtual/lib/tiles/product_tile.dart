import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/screens/product_screen.dart';

class ProductTile extends StatelessWidget {
  /*Essa classe tem o intuito de contruir o corpo da category screen
  * podendo ser uma lista ou grade com os produtos do firebase*/

  final String type;
  final ProductData product;

  //Construtor recebendo o tipo list ou grade com informações do firebase
  ProductTile(this.type, this.product);

  @override
  Widget build(BuildContext context) {
    //InkWell quando voce toca no botao, ele faz uma animacao de toque diferente do GestureDetector
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProductScreen(product)));
      },
      child: Card(
        //O cartao tem um filho que pode ser coluna ou linha e depedendo do tipo
        //construir o cartao com o tipo, se for coluna as informacoes sera em
        // disponibilizadas em coluna, se for list sera em linha
        child: type == "grid"
            ? Column(
                //o tipo stretch vai esticar o conteudo dentro
                crossAxisAlignment: CrossAxisAlignment.stretch,
                //A imagem vai fica no inicio do cartao
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  //Eh colocado a imagem
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  //Vai coloca o resto das informacoes do produto
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      children: <Widget>[
                        Text(
                          product.title,
                          style: TextStyle(fontWeight: FontWeight.w300),
                        ),
                        Text(
                          "R\$ ${product.price.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
                ],
              )
            : Row(
                children: <Widget>[
                  Flexible(
                    //Coloca a quantia de espaco pro espaco
                    flex: 1,
                    child: Image.network(
                      product.images[0],
                      fit: BoxFit.cover,
                      height: 250.0,
                    ),
                  ),
                  Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              product.title,
                              style: TextStyle(fontWeight: FontWeight.w300),
                            ),
                            Text(
                              "R\$ ${product.price.toStringAsFixed(2)}",
                              style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
      ),
    );
  }
}
