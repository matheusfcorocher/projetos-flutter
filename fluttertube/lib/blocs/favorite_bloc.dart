import 'dart:async';
import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteBloc implements BlocBase {

  Map<String, Video> _favorites = {};

  //BehaviorSubject envia o ultimo dado que foi enviado, ja comeca com um mapa
  //vazio
  final StreamController<Map<String, Video>> _favController = BehaviorSubject
  <Map<String, Video>>.seeded({});

  Stream<Map<String, Video>> get outFav => _favController.stream.asBroadcastStream();

  FavoriteBloc() {
    SharedPreferences.getInstance().then((prefs) {
      //Se tiver favoritos em prefs, os favoritos, decodifica o json para o mapa
      // de videos, sendo k e v = keys e values e escrevendo como um mapa do tipo
      // string e videos e depois add no _favorites atraves do
      // controlador _favController
      if(prefs.getKeys().contains("favorites")) {
        _favorites = json.decode(prefs.getString("favorites")).map((k, v) {
          return MapEntry(k, Video.fromJson(v));
        }
        ).cast<String, Video>();
      }

      _favController.add(_favorites);
    });
  }


  void toggleFavorite(Video video) {
    if(_favorites.containsKey(video.id))//Se tiver preenchido a estrela na string do video
      _favorites.remove(video.id);//retira a estrela
    else
      _favorites[video.id] = video;//adiciona a estrela

    _favController.sink.add(_favorites);

    _saveFav();
  }
  
  void _saveFav() {
    SharedPreferences.getInstance().then((prefs) {
      prefs.setString("favorites", json.encode(_favorites));
    });
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
  }

  @override
  void dispose() {
      _favController.close();
  }

  @override
  // TODO: implement hasListeners
  bool get hasListeners => null;

  @override
  void notifyListeners() {
    // TODO: implement notifyListeners
  }

  @override
  void removeListener(listener) {
    // TODO: implement removeListener
  }

}