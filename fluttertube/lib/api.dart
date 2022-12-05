//Esse arquivo dart representa a chave de API do Youtube Data API v3
//fonte : console.developers.google
import 'dart:convert';

import 'package:http/http.dart' as http;

import 'models/video.dart';

const API_KEY = "YOUR_GOOGLE_API_KEY";

class Api {

  String _search;
  String _nextToken;

  Future<List<Video>> search(String search) async {
    //Essa funcao vai pesquisar a string dada pelo usuario no youtube

    _search = search;

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$search&type=video&key=$API_KEY&maxResults=10"
    );

    return decode(response);

  }

  Future<List<Video>> nextPage() async {

    http.Response response = await http.get(
        "https://www.googleapis.com/youtube/v3/search?part=snippet&q=$_search&type=video&key=$API_KEY&maxResults=10&pageToken=$_nextToken"
    );

    return decode(response);

  }

  List<Video> decode(http.Response response) {
    // A funcao de decode eh verificar se a resposta da API deu certo,errado,etc...
    if(response.statusCode == 200) {
      //200 - representa que deu certo

      var decoded = json.decode(response.body);

      _nextToken = decoded["nextPageToken"];

      //Os videos retirados da lista items da API eh usado .map para acessa-los
      // e depois eh transformados em objetos videos
      List<Video> videos = decoded["items"].map<Video>(
          (map) {
            return Video.fromJson(map);
          }
      ).toList();

      return videos;

    } else {
      throw Exception("Failed to load videos");
    }
  }

}
