import 'package:flutter/material.dart';
import 'package:xlo/models/ad.dart';

class BottomBar extends StatelessWidget {

  final Ad ad;

  BottomBar(this.ad);

  @override
  Widget build(BuildContext context) {
    return Positioned(
        left: 0,
        right: 0,
        bottom: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              height: 38,
              margin: const EdgeInsets.symmetric(horizontal: 26),
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: const BorderRadius.all(Radius.circular(19))
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: GestureDetector(
                        onTap: () {},
                        child: Container(
                          height: 25,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border(
                              right: BorderSide(
                                color: Colors.black45,
                              ),
                            ),
                          ),
                          child: Text(
                              'Ligar',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 15,
                              ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {},
                      child: Text(
                        'Chat',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 15
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15,),
            Container(
              decoration: BoxDecoration(
                color: const Color.fromRGBO(249, 249, 249, 1),
                border: Border(
                  top: BorderSide(color: Colors.grey[400])
                ),
              ),
              alignment: Alignment.center,
              height: 38,
              child: Text(
                'Matheus(anunciante)',
                style: TextStyle(
                  fontWeight: FontWeight.w300
                ),
              ),
            ),
          ],
        ),
    );
  }
}
