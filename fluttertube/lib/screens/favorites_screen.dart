import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:flutter_youtube/flutter_youtube.dart';
import 'package:fluttertube/api.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/models/video.dart';

class Favorites extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final fbloc = BlocProvider.getBloc<FavoriteBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Favoritos'),
        centerTitle: true,
        backgroundColor: Colors.black87,
      ),
      backgroundColor: Colors.black87,
      body: StreamBuilder<Map<String, Video>>(
          stream: fbloc.outFav,
          initialData: {},
          builder: (context, snapshot) {
            return ListView(
              //O mapa apresenta o values
              children: snapshot.data.values.map((v) {
                return InkWell(
                  onTap: () {
                    //quando da uma batida em favoritos, ele da o play
                    FlutterYoutube.playYoutubeVideoById(
                        apiKey: API_KEY,
                        videoId: v.id
                    );
                  },
                  onLongPress: () {
                    fbloc.toggleFavorite(v);
                  },
                  child: Row(
                    children: <Widget>[
                      Container(
                        width:100,
                        height: 50,
                        child: Image.network(v.thumb),
                      ),
                      Expanded(
                          child: Text(
                            v.title, style: TextStyle(color: Colors.white70),
                            maxLines: 2,
                          ),

                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
      ),
    );
  }
}
