import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/datas/cart_product.dart';
import 'package:lojavirtual/datas/product_data.dart';
import 'package:lojavirtual/models/cart_model.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/cart_screen.dart';
import 'package:lojavirtual/screens/login_screen.dart';

class ProductScreen extends StatefulWidget {
  /*Cria a tela do produto quando selecionado*/

  //Recebe o produto
  final ProductData product;

  //Cria um construtor de produto
  ProductScreen(this.product);

  //Repassa o o produto para tela dinamica
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {
  final ProductData product;

  //Essa variavel vai receber o texto de Size para comparar
  String size;

  //Recebe o produto do estado e salvando o produto dentro da variavel product
  // assim nao precisa chamar widget.product para chamar o produto apenas usa product
  _ProductScreenState(this.product);

  @override
  Widget build(BuildContext context) {
    final Color primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          //imagem do produto
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: product.images.map((url) {
                return NetworkImage(url);
              }).toList(),
              //dotSize eh ponto que fica sobre a imagem
              dotSize: 4.0,
              dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: primaryColor,
              autoplay: false,
            ),
          ),
          //Informações do produto
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: primaryColor),
                ),
                //Espaco entre o texto preco e texto tamanho
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                //Botões de tamanho do produto
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    //espaco simetrico
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    //Se voce nao coloca uma direcao para gridview ele adota a
                    //vertical
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    //Esta pegando as strings sizes do firebase e mapenado
                    // passando uma funcao
                    children: product.sizes.map((s) {
                      //Quando aperta no tamanho ele vai selecionar
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            size = s;
                          });
                        },
                        child: Container(
                          //Decoração da caixa
                          decoration: BoxDecoration(
                              //Decoracao da caixa para ficar circular a borda
                              borderRadius:
                                  BorderRadius.all(Radius.circular(4.0)),
                              //Estiliza a borda
                              border: Border.all(
                                  //troca a cor da borda quando for selecionado
                                  color: s == size
                                      ? primaryColor
                                      : Colors.grey[500],
                                  //Aumenta a grossura da borda em 3pxls
                                  width: 3.0)),
                          //Tamanho da Caixa
                          width: 50.0,
                          //Alinhamento do texto dentro da borda
                          alignment: Alignment.center,
                          //Texto dentro da caixa
                          child: Text(s),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                //Espaco entre botao de compra e seleção de tamanhos
                SizedBox(
                  height: 16.0,
                ),
                //Botao de compra
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    //Quando o tamanho nao estiver selecionado,
                    // ele ficara desabilitado
                    onPressed: size != null ? () {
                      if(UserModel.of(context).isLoggedIn()) {
                        //adiciona ao carrinho se o usuario estiver logado
                        CartProduct cartProduct = CartProduct();
                        cartProduct.size = size;
                        cartProduct.quantity = 1;
                        cartProduct.pid = product.id;
                        cartProduct.category = product.category;
                        cartProduct.productData = product;

                        CartModel.of(context).addCartItem(cartProduct);

                        Navigator.of(context).push(
                            //Vai manda para tela do carrinho
                            MaterialPageRoute(builder: (context) => CartScreen())
                        );
                      }
                      else {
                        //Navigator.of(context) esta buscando um tipo Navigator
                        // dentro do contexto,
                        Navigator.of(context).push(
                          //Vai manda para tela de login
                          MaterialPageRoute(builder: (context) => LoginScreen())
                        );


                      }
                    } : null,
                    child: Text(
                      UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho"
                          : "Entre para Comprar"
                      ,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    color: primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                //Espaco entre o botao adicionar e descricao
                SizedBox(
                  height: 16.0,
                ),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
