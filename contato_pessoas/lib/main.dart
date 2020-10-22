import 'package:com/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:com/ui/home_page.dart';

void main() {
  runApp(MaterialApp(
    title: "Agenda de Contatos",
    home: HomePage(),
    //Retira a faixa do banner de debug
    debugShowCheckedModeBanner: false,
  )
  );
}