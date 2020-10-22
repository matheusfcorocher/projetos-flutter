import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {

  ChatMessage(this.data, this.mine);

  final Map<String, dynamic> data;
  //Se for meu
  final bool mine;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Row(
        children: <Widget>[
          //Se nao for meu fica no lado direito
          !mine ?
          Padding(
              padding: const EdgeInsets.only(right: 16),
              child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ) : Container(),
          Expanded(
              child: Column(
                //alinhamento da coluna dependendo do usuario
                crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: <Widget>[
                  data["imgUrl"] != null ? Image.network(data["imgUrl"], width: 250,):
                      Text(
                        data["text"],
                        //Alinhamento do texto depedendo do usuario
                        textAlign: mine ? TextAlign.end : TextAlign.start,
                        style: TextStyle(
                          fontSize: 16
                        ),
                      ),
                  Text(
                      data['senderName'],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                  ),
                ],
              ),
          ),
          //Se for meu fica no lado esquerdo
          mine ?
          Padding(
            padding: const EdgeInsets.only(left: 16),
            child: CircleAvatar(
              backgroundImage: NetworkImage(data["senderPhotoUrl"]),
            ),
          ) : Container(),
        ],
      ),
    );
  }
}
