import 'package:flutter/material.dart';
import 'package:login_with_animations/screens/login/widgets/form_container.dart';
import 'package:login_with_animations/screens/login/widgets/sign_up_button.dart';
import 'package:login_with_animations/screens/login/widgets/stagger_animation.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:login_with_animations/screens/home/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin{

  AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 2),
    );

    _animationController.addStatusListener((status) {
      //Quando a animacao acaba muda para home_screen
      if(status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => HomeScreen() )
        );
      }
    });
  }


  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //Usa timeDilation para diminuir 1 vezes o tempo normal . Ex
    timeDilation = 1;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/background.jpg"),
              fit: BoxFit.cover,
          )
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            //Usa o widget stack pois um componente vai passar em cima do outro  
            Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.only(top: 70, bottom: 32),
                          child: Image.asset(
                              "images/tickicon.png",
                              width: 150,
                              height: 150,
                              fit: BoxFit.contain,
                          ),
                      ),
                      FormContainer(),
                      SignUpButton(),
                    ],
                  ),
                  StaggerAnimation(
                    //passa apenas a vista animacao
                    controller :_animationController.view,
                  ),
                ],
              )
          ],
        ),
      ),
    );
  }
}
