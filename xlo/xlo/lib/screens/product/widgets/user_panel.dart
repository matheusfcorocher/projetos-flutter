import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlo/models/ad.dart';

class UserPanel extends StatelessWidget {

  final Ad ad;

  UserPanel(this.ad);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 10),
            child: Text(
              "Anunciante",
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
        ),
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[200],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                  'Matheus',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
              ),
              const SizedBox(height: 10,),
              Text(
                "Na OLX desde de hoje",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
