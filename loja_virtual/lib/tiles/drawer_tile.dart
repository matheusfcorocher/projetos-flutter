import 'package:flutter/material.dart';

class DrawerTile extends StatelessWidget {
  /*O DrawerTile vai gerar o Menu de opções
  */


  final IconData icon;
  final String text;
  final PageController controller;
  final int page;

  DrawerTile(this.icon, this.text, this.controller, this.page);

  @override
  Widget build(BuildContext context) {
    //retorna Material para voltar um efeito visual
    //DrawerTile vai enviar o icone e texto e construir
    //a caixa de opções
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.of(context).pop();
          controller.jumpToPage(page);
        },
        child: Container(
          height: 68.0,
          child: Row(
            children: <Widget>[
              Icon(
                  icon,
                  size: 32.0,
                  color: controller.page.round() == page ?
                      Theme.of(context).primaryColor : Colors.grey[700],
              ),
              SizedBox(width: 32.0,),
              Text(
                  text,
                  style: TextStyle(
                    fontSize: 10.0,
                    //controller.page eh um numero double,por isso que arredonda
                    color: controller.page.round() == page ?
                    //se for a mesma pagina muda de cor para azul senao e cinza
                    Theme.of(context).primaryColor : Colors.grey[700],
                  ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
