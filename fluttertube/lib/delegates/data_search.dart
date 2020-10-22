import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DataSearch extends SearchDelegate<String>{
  @override
  List<Widget> buildActions(BuildContext context) {
    //Representa qualquer botao, esse botao representa a limpeza do texto
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    //Representa o botao que fica no lado esquerdo, ou seja, o logo do youtube, ou seja volta
    return IconButton(
        icon: AnimatedIcon(
            icon: AnimatedIcons.menu_arrow,
            progress: transitionAnimation
        ),
        onPressed: () {
          close(context, null);
        }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //Adia o fechamento da tela de pesquisa para que consiga desenhar a seguinte
    // tela
    Future.delayed(Duration.zero).then((_) => close(context, query));
    // Volta para a tela home_screen, se voce quiser pode construir nessa tela
    // sendo igual buildSuggestions
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if(query.isEmpty)
      return Container();
    else
      return FutureBuilder<List>(
        future: suggestions(query),
        builder: (context, snapshot) {
          if(!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          else {
            return ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(snapshot.data[index]),
                    leading: Icon(Icons.play_arrow),
                    onTap: () {
                      close(context, snapshot.data[index]);
                    },
                  );
                },
                itemCount: snapshot.data.length,
            );
          }
        },
      );
  }

  Future<List> suggestions(String search) async {
    //Essa funcao retorna sugestoes para o usuario enquanto ele digita
    http.Response response = await http.get(
        "http://suggestqueries.google.com/complete/search?hl=en&ds=yt&client=youtube&hjson=t&cp=1&q=$search&format=5&alt=json"
    );

    if(response.statusCode == 200) {
      json.decode(response.body)[1].map((values) {
        //Acessa o indice 0 do json pois eh o contem a string relacionada
        return values[0];
      }).toList();
    }else {

    }throw Exception("Failed to load suggestions");
  }


}