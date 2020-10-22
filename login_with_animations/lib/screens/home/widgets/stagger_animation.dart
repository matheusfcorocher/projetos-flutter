import 'package:flutter/material.dart';

import 'animation_list_view.dart';
import 'fade_container.dart';
import 'home_top.dart';

class StaggerAnimation extends StatelessWidget {
  final AnimationController controller;

  StaggerAnimation({@required this.controller})
      : containerGrow = CurvedAnimation(parent: controller, curve: Curves.ease),
        listSlidePosition = EdgeInsetsTween(
          begin: EdgeInsets.only(bottom: 0),
          end: EdgeInsets.only(bottom: 80),
        ).animate(CurvedAnimation(
            parent: controller,
            curve: Interval(
                0.325, //Quando estiver 32.5% da um intervalo e
                0.8, // volta quando estiver 80% do tempo
                curve: Curves.ease))
        ),
        fadeAnimation = ColorTween(
            begin: Color.fromRGBO(247, 64, 106, 1.0),
            end: Color.fromRGBO(247, 64, 106, 0.0)
          ).animate(CurvedAnimation(
            parent: controller,
            curve: Curves.easeInCirc
        ));

  final Animation<double> containerGrow;
  final Animation<EdgeInsets> listSlidePosition;
  final Animation<Color> fadeAnimation;

  Widget _buildAnimation(BuildContext context, Widget child) {
    return Stack(
      children: <Widget>[
        ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            HomeTop(
              containerGrow: containerGrow,
            ),
            AnimatedListView(
              listSlidePosition: listSlidePosition,
            ),
          ],
        ),
        IgnorePointer(
          //ignora os toques do widget e interage com a parte de baixo
          child: FadeContainer(
            //Representa um bloco que vai fazer a transicao da login_screen para home_screen
              fadeAnimation: fadeAnimation
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: AnimatedBuilder(animation: controller, builder: _buildAnimation),
      ),
    );
  }
}
