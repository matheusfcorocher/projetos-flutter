import 'package:com/ui/get_gif.dart';
import 'package:flutter/material.dart';
import 'package:com/ui/home_page.dart';
import 'package:com/ui/get_gif.dart';

void main() {
    runApp(MaterialApp(
        home: HomePage(),
        theme: ThemeData(
            hintColor: Colors.white,
            primaryColor: Colors.white,
            //modifica a cor do componente input(onde usuario escreve)
            inputDecorationTheme: InputDecorationTheme(
                enabledBorder:
                //modifica a cor da borda
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintStyle: TextStyle(color: Colors.white),
            )
        ),
    ),
    );
}

