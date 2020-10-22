import 'package:flutter/material.dart';

import 'list_data.dart';

class AnimatedListView extends StatelessWidget {

  final Animation<EdgeInsets> listSlidePosition;

  AnimatedListView({@required this.listSlidePosition});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: <Widget>[
        ListData(
          title: "Estudar Flutter",
          subtitle: "Com o curso do Daniel Ciofi",
          image: AssetImage("images/user.jpg"),
          margin: listSlidePosition.value * 2,//multiplica a margin 80*2 - 160
        ),
        ListData(
          title: "Estudar Flutter",
          subtitle: "Com o curso do Daniel Ciofi",
          image: AssetImage("images/user.jpg"),
          margin: listSlidePosition.value * 1,//multiplica a margin 80*1 - 80
        ),
        ListData(
          title: "Estudar Flutter",
          subtitle: "Com o curso do Daniel Ciofi",
          image: AssetImage("images/user.jpg"),
          margin: listSlidePosition.value * 0,//multiplica a margin 80*0 - 0
        ),
      ],
    );
  }
}
