import 'package:flutter/material.dart';

class FadeContainer extends StatelessWidget {

  final Animation<Color> fadeAnimation;

  FadeContainer({this.fadeAnimation});

  @override
  Widget build(BuildContext context) {
    return Hero(
      //Hero eh um widget para manter um objeto para animacao,ver documentacao
      tag: 'fade',
      child: Container(
        decoration: BoxDecoration(
          color: fadeAnimation.value,//animacao para transicao de cor da tela
        ),
      ),
    );
  }
}
