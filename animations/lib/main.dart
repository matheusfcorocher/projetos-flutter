import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Animations intro',
      debugShowCheckedModeBanner: false,
      home: LogoApp(),
    );
  }
}

class LogoApp extends StatefulWidget {
  @override
  _LogoAppState createState() => _LogoAppState();
}

class _LogoAppState extends State<LogoApp> with SingleTickerProviderStateMixin{

  //O controlador eh o pai das animacoes
  AnimationController controller;
  Animation<double> animation;
  Animation<double> animation2;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: MatheusTransition(
        child: LogoWidget(),
        animation: animation,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    //vsync eh avisado pelo mixin quando vai refazer a tela
    controller = AnimationController(
        vsync: this,
        //recomendacao de 0 a 2s
        duration: Duration(seconds: 2),
    );

    //Animations e Tween precisa ser especificado o tipo de animacao
    // .. representa programacao em cascata(notacao de cascata),
    // ou seja depois do tween animar
    // ele vai acrescentar um listener

    //CurvedAnimation cria uma curva de crescimento nao linear, ou seja, cresce
    // na forma quadratica,exponencial,etc... ou outra curva
    //Pesquisa Curves.curva, etc...
    animation = CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);
    animation.addStatusListener((status) {
      if(status == AnimationStatus.completed) {
        //decresce o tamanho do logo
        controller.reverse();
      }
      else if(status == AnimationStatus.dismissed) {
        //dismissed quando a figura chega a 0
        //acrescenta tamanho ao logo
        controller.forward();
      }
    });



    //Vai acrescenta valores de 0 a 300,forward para frente
    controller.forward();

  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

}

/*class AnimatedLogo extends AnimatedWidget {
  //Essa classe representa um o logo da animacao

  //Toda vez que muda o animation sera refeito o logo, animation em build
  AnimatedLogo(Animation<double> animation) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return Center(
      child: Container(
        //Voce pode usar o controller.value
        height: animation.value,
        width: animation.value,
        child: FlutterLogo(

        ),
      ),
);
}

}*/

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FlutterLogo(),
    );
  }
}

class MatheusTransition extends StatelessWidget {

  final Widget child;
  final Animation<double> animation;

  //Representa as curvas de animacoes
  final sizeTween = Tween<double>(begin: 0, end: 300);
  final opacityTween = Tween<double>(begin: 0.1, end: 1);

  MatheusTransition({this.child, this.animation});



  @override
  Widget build(BuildContext context) {
    return Center(
      //AnimatedBuilder vai refazer animacao quando houver alguma mudanca
      child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Opacity(
              //evaluate converte o valor da opacidade para animacao
              opacity: opacityTween.evaluate(animation).clamp(0, 1.0),
              child: Container(
                height: sizeTween.evaluate(animation),
                width: sizeTween.evaluate(animation),
                child: child,
              ),
            );
          },
          child: child,
      ),
    );
  }
}



