import 'dart:convert';
import 'package:com/ui/get_gif.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /*Variáveis usadas em _gitGifs*/
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    /*O intuito dessa função é se _search(string em que o usuario pesquisar por gifs) for vazia, ele mostrará os gifs que estão em tendência(mais visitados)
    * Se o usuário tiver pesquisado alguma palavra, vai mostra gifs relacionado à essa palavra ou string
    * Depois disso, transforma essa requisição em um tipo de dado json
    * E também muda o _offset(quantidade de gifs para mostrar ao usuário depois que ela já viu os 25 primeiros)*/

    //Variável do futuro
    http.Response response;
    //Se a pesquisa for vazia ou _search for nulo, volta para o trending
    if (_search == null || _search.isEmpty) {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=KMv6H8F9IVtZm1Mjg3acNHVuHuD2CY3V&limit=26&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=KMv6H8F9IVtZm1Mjg3acNHVuHuD2CY3V&q=$_search&limit=25&offset=$_offset&rating=G&lang=en");
    }

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        //o título pode aceitar imagem além de string escrita
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(children: <Widget>[
        Padding(
          padding: EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
              labelText: "Pesquise Aqui!!",
              labelStyle: TextStyle(color: Colors.white),
              border: OutlineInputBorder(),
            ),
            style: TextStyle(color: Colors.white, fontSize: 18.0),
            textAlign: TextAlign.center,
            //A função onSubmitted vai pega o texto escrito no input(text) e vai
            // atribuir a variável _search, com setState que vai atualiza a tela
            // do celular
            onSubmitted: (text) {
              setState(() {
                _search = text;
                //Reseta _offset quando faz uma nova pesquisa
                _offset = 0;
              });
            },
          ),
        ),
        //Usa a classe Expanded() para que os itens dela ocupe proporcionalmente a tela
        Expanded(
          //Como os itens dentro do Expanded() serão gifs do futuro,então usa um construtor do futuro
          child: FutureBuilder(
              // o futuro é especificado pela função _getGifs()
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  //O ConnectionState.none , caso ele esteja carregando nada, fará uma animação de carregamento
                  case ConnectionState.none:
                    return Container(
                      width: 200.0,
                      height: 200.0,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        //espessura do circulo
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError)
                      return Container();
                    else
                      return _createGifTable(context, snapshot);
                }
              }),
        ),
      ]),
    );
  }

  int _getCount(List data) {
    //Não está sendo feito nenhuma pesquisa
    if (_search == null) {
      return data.length;
    }
    //Retorna +1 para mostrar o quadrinho de + gifs quando pesquisa algo
    else
      return data.length + 1;
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    /*O intuito dessa função é de criar a grade de gifs*/
    return GridView.builder(
        //tod o bloco grade vai ficar com afastamento 10 pxls em todo os lados
        padding: EdgeInsets.all(10.0),
        //gridDelegate é a forma como vai organiza os itens
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //quantidade de itens disponiveis em uma linha
          crossAxisSpacing: 10.0, //espaço entre os itens
          mainAxisSpacing: 10.0, //espaço principal
        ),
        //Mostra a quantidade de gifs na tela
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          //Se a minha pesquisa for nula(trending) ou não for o último item
          if (_search == null || index < snapshot.data["data"].length) {
            //Ela vai costruir cada item do grid através de um indice
            return GestureDetector(
              //Essa função detecta click do usuário e vai para outra pagina
              //Sem ela,os gifs são imagens paradas
              //Foi pego o arquivo json e escolhido um tipo de foto, depois do
              // data... representa o caminho da url
              child: FadeInImage.memoryNetwork(
                  //placeholder - imagem que vai ficar no lugar da outra antes de
                  // ela aparecer
                  placeholder: kTransparentImage,
                  image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                  height: 300.0,
                  fit: BoxFit.cover,
              ),
              onTap: () {
                //route é como se fosse a ponte de duas telas(caminho)
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
                );
              },
              onLongPress: () {
                Share.share(snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
              },
            );
          }
          //Se tiver pesquisa e for a última imagem
          else {
            return Container(
              child: GestureDetector(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 70.0,
                    ),
                    Text("Carregar mais..",
                        style: TextStyle(color: Colors.white, fontSize: 22.0)),
                  ],
                ),
                //Quando o usuário clickar para + gifs
                onTap: () {
                  setState(() {
                    //Aumenta o offset
                    _offset += 25;
                  });
                },
              ),
            );
          }
        });
  }
}
