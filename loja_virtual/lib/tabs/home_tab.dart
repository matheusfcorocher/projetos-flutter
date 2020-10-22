import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:transparent_image/transparent_image.dart';

class HomeTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //_buildBodyBack eh um widget que vai conter o
    //degrade de cor rosa,usando o gradiente linear
    Widget _buildBodyBack() => Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            colors: [
              //A primeira cor eh mais escura e a
              // 2 cor eh mais clara
              Color.fromARGB(255, 211, 118, 138),
              Color.fromARGB(255, 211, 118, 168)
            ],
          //Comeca no topo esquerdo a cor
          begin: Alignment.topLeft,
          //Termina no canto direito inferior da tela
          end: Alignment.bottomRight
        ),
      ),
    );

    //Usa a classe Stack, pois ela permite colocar
    //widgets em cima do outro
    return Stack(
      children: <Widget>[
        _buildBodyBack(),
        CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              //floating = flutuante
              floating: true,
              //snap - desaparece quando arrastado para baixo e
              // reaparece em cima
              snap: true,
              //fundo transparente
              backgroundColor: Colors.transparent,
              //elevacao 0 para nao ter nenhuma sombra
              elevation: 0.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text("Novidades"),
                centerTitle: true,
              ),
            ),
            FutureBuilder<QuerySnapshot>(
              future: Firestore.instance.
              collection("home").orderBy("pos").getDocuments(),
              builder: (context, snapshot) {
                if(!snapshot.hasData) {
                  //Usa o sliver, pois o custom scrollView eh feito a partir de slivers
                  return SliverToBoxAdapter(
                    child: Container(
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                  );
                }
                else
                {
                  return SliverStaggeredGrid.count(
                      //Ele n vai carregar os itens dinamicamente com
                      // o rolar da tela, ele vai carregar todos os documentos
                      // ao mesmo tempo
                      crossAxisCount: 2,
                      mainAxisSpacing: 1.0,
                      crossAxisSpacing: 1.0,
                      staggeredTiles: snapshot.data.documents.map(
                          (doc) {
                            // retorna cada imagem como StaggeredTile
                            return StaggeredTile.count(doc.data["x"], doc.data["y"]);
                          }
                      ).toList(),
                    //Em vez de transforma cada imagem manualmente, passa
                    // um mapa para criar essas imagens
                    children: snapshot.data.documents.map(
                        (doc) {
                          //FadeinImage vai aparecer a imagem lentamente
                          return FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: doc.data["image"],
                              fit: BoxFit.cover,
                          );
                        }
                    ).toList(),

                  );
                }
              },
            ),

          ],
        ),
      ],
    );
  }
}
