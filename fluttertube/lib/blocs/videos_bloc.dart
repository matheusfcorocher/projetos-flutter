import 'package:fluttertube/api.dart';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:fluttertube/models/video.dart';
import 'dart:async';

class VideosBloc implements BlocBase {

  Api api;

  List<Video> videos = <Video>[];

  final StreamController<List<Video>> _videosController = StreamController<List<Video>>();
  Stream get outVideos => _videosController.stream;//Representa o output da stream,
  // ou seja vai poder manipular os dados da pesquisa e manda para o StreamBuilder da main

  final StreamController<String> _searchController = StreamController<String>();
  Sink get inSearch => _searchController;//Representa input da stream

  VideosBloc() {
    api = Api();

    _searchController.stream.listen(_search);
  }

  void _search(String search) async {
    if(search != null) {
      _videosController.sink.add([]);
      //Recebe a pesquisa feita pelo usuario e atribue em videos controller
      videos = await api.search(search);
    }
    else {
      //Vai para a proxima pagina e junta 2 listas
      videos += await api.nextPage();
    }

    _videosController.sink.add(videos);

  }

  @override
  void dispose() {
    _videosController.close();
  }

  @override
  void addListener(listener) {
    // TODO: implement addListener
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