import 'package:flutter/material.dart';
import 'package:lojavirtual/models/user_model.dart';
import 'package:lojavirtual/screens/login_screen.dart';
import 'package:lojavirtual/tiles/drawer_tile.dart';
import 'package:scoped_model/scoped_model.dart';

class CustomDrawer extends StatelessWidget {
  /*O Drawer eh o widget da lateral quando voce arrasta da direita para esquerda,
  ele aparece
  */

  final PageController pageController;
  //Recebe um pageController para enviar para o drawertile
  // e interagir quando for clicka mudar a cor e muda a página
  CustomDrawer(this.pageController);

  @override
  //_buildBodyBack eh um widget que vai conter o
  //degrade de cor rosa,usando o gradiente linear
  Widget _buildDrawerBack() => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
          colors: [
            //A primeira cor eh mais escura e a
            // 2 cor eh mais clara
            Color.fromARGB(255, 283, 236, 241),
            Colors.white
          ],
          //Comeca no topo esquerdo a cor
          begin: Alignment.topCenter,
          //Termina no canto direito inferior da tela
          end: Alignment.bottomCenter
      ),
    ),
  );

  Widget build(BuildContext context) {
    return Drawer(
      child:Stack(
        children: <Widget>[
          _buildDrawerBack(),
          ListView(
            padding: EdgeInsets.only(left:32.0, top:16.0),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 0.0),
                padding: EdgeInsets.fromLTRB(0.0, 16.0, 16.0, 8.0),
                height: 170.0,
                child: Stack(
                  //Usa o stack para posicionar os componentes dentro
                  // de um quadrado
                  children: <Widget>[
                    Positioned(
                        top: 0.0,
                        left: 0.0,
                        child: Text("Flutter´s\nClothing",
                          style: TextStyle(
                              fontSize: 34.0,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                    ),
                    Positioned(
                      left: 0.0,
                      bottom: 0.0,
                      child: ScopedModelDescendant<UserModel>(
                        builder: (context, child, model) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text("Olá, ${!model.isLoggedIn() ? "" : model.userData["name"]}",
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              GestureDetector(
                                child:  Text(
                                  !model.isLoggedIn() ?
                                  "Entre ou cadastre-se >"
                                  : "Sair",
                                  style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                onTap: () {
                                  //Se o usuario nao estiver logado
                                  if(!model.isLoggedIn()) {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) => LoginScreen())
                                    );
                                  }
                                  else
                                    model.signOut();
                                },
                              ),
                            ],
                          );
                      },
                      )
                    ),
                  ],
                ),
              ),
              Divider(),
              DrawerTile(Icons.home, "Inicio", pageController, 0),
              DrawerTile(Icons.list, "Produtos", pageController, 1),
              DrawerTile(Icons.location_on, "Lojas", pageController, 2),
              DrawerTile(Icons.playlist_add_check, "Meus Pedidos", pageController, 3),
            ],
          ),
        ],
      ),
    );
  }
}
