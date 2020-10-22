import 'package:flutter/material.dart';

class ShipCard extends StatelessWidget {
  //Essa classe representa o calculo do frete
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: ExpansionTile(
        title: Text(
          "Calcular Frete",
          textAlign: TextAlign.start,
          style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey[700]
          ),
        ),
        leading: Icon(Icons.location_on),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: "Digite seu corpo"
              ),
              //Coloca o coupon inicial se tiver um
              initialValue: "Digite seu CEP",
              onFieldSubmitted: (text) {

              },
            ),
          )
        ],
      ),
    );
  }
}
