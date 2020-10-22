import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:fluttertube/blocs/favorite_bloc.dart';
import 'package:fluttertube/blocs/videos_bloc.dart';
import 'package:fluttertube/delegates/data_search.dart';
import 'package:fluttertube/models/video.dart';
import 'package:fluttertube/widgets/video_tile.dart';

import 'favorites_screen.dart';

class Home extends StatelessWidget {
  //Bloc pattern nao precisa stful
  VideosBloc vbloc;

  @override
  Widget build(BuildContext context) {

    vbloc = BlocProvider.getBloc<VideosBloc>();

    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 25,
          child: Image.asset("images/youtube.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.green,
        actions: <Widget>[
          Align(
            //Usa esse widget para o texto fica no meio
            alignment: Alignment.center,
            child: StreamBuilder<Map<String, Video>>(
                initialData: {},
                builder: (context, snapshot) {
                  if(snapshot.hasData)
                    return Text("${snapshot.data.length}");
                  else
                    return Container();
                },
                stream: BlocProvider.getBloc<FavoriteBloc>().outFav,
            ),
          ),
          IconButton(
              icon: Icon(Icons.star),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>Favorites(),
                )
                );
              }
          ),
          IconButton(
              icon: Icon(Icons.search),
              onPressed: () async {
                String result = await showSearch(context: context, delegate: DataSearch());
                if (result != null) {
                  vbloc.inSearch.add(result);
                }
              }
          )
        ],
      ),
      backgroundColor: Colors.green,
      body: StreamBuilder(
        stream: vbloc.outVideos,
        builder: (context, snapshot) {
          if(snapshot.hasData)
            return ListView.builder(
                itemBuilder: (context, index) {
                  if(index < snapshot.data.length) {
                    return VideoTile(snapshot.data[index]);
                  }
                  else if (index > 1){
                    //Representa que acabou de abrir o app
                    //O usuario quer ir pra proxima pagina
                    vbloc.inSearch.add(null);
                    return Container(
                      height: 40,
                      width: 40,
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.amber),),
                    );
                  }
                  else {
                    return Container();
                  }
                },
                itemCount: snapshot.data.length + 1// truque para pensar que tem +1 item,
            );
          else
            return Container();
        },
      ),
    );
  }
}
