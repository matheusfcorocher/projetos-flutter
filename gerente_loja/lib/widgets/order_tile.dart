import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'order_header.dart';

class OrderTile extends StatelessWidget {

  final DocumentSnapshot order;

  OrderTile(this.order);

  final states = [
    '', 'Em preparação', 'Aguardando Entrega', 'Entregue'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Card(
        child: ExpansionTile(
          key: Key(order.documentID),
          initiallyExpanded: order.data['status'] != 4,
          title: Text(
              "#${order.documentID.substring(
                  order.documentID.length - 7,
                  order.documentID.length )} - ${states[order.data["status"] - 1]}",
              style: TextStyle(color: order.data['status'] != 4 ?
                Colors.grey[850] : Colors.green),
            ),
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 0, bottom: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    OrderHeader(order),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: order.data['products'].map<Widget>((product) {
                        return ListTile(
                          title: Text(product['product']['title'] + ' - ' + product['size']),
                          subtitle: Text(product['category'] + '/' + product['pid']),
                          trailing: Text(
                            product['quantity'].toString(),
                            style: TextStyle(fontSize: 20),
                          ),
                          contentPadding: EdgeInsets.zero,
                        );
                      }).toList()
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        FlatButton(
                            onPressed: () {
                              Firestore.instance.collection('users').
                              document(order['clientId']).collection('orders').
                              document(order.documentID).delete();
                              order.reference.delete();
                            },
                            child: Text('Excluir'),
                            textColor: Colors.red,
                        ),
                        FlatButton(
                          onPressed: order.data['status'] > 1 ? () {
                            order.reference.updateData(
                                {"status" : order.data["status"] - 1}
                                );
                          } : null,
                          child: Text('Regredir'),
                          textColor: Colors.grey[850],
                        ),
                        FlatButton(
                          onPressed: order.data['status'] < 4 ? () {
                            order.reference.updateData(
                                {"status" : order.data["status"] + 1}
                            );
                          } : null,
                          child: Text('Avançar'),
                          textColor: Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
            ),
          ],
        ),
      ),
    );
  }
}
