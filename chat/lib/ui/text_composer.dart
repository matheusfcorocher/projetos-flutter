import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class textComposer extends StatefulWidget {
  //Essa classe representa a parte de baixo de mandar mensagem

  textComposer(this.sendMessage);

  final Function({String text, File imgFile}) sendMessage;

  @override
  _textComposerState createState() => _textComposerState();
}

class _textComposerState extends State<textComposer> {

  //Variável determina se o widget text_composer aparece ou não
  bool _isComposing = false;
  final TextEditingController _controller = TextEditingController();

  void _reset() {
    //Apaga o texto depois de enviado
    _controller.clear();
    setState(() {
      //atualiza o botão de envio, depois que envia o texto
      _isComposing = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: <Widget>[
          IconButton(
              icon: Icon(Icons.photo_camera),
              onPressed: () async{
                //Recebe um arquivo com a foto tirada
                final File imgFile =
                await ImagePicker.pickImage(source: ImageSource.camera);
                if (imgFile == null)
                  return;
                widget.sendMessage(imgFile : imgFile);

              },
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration.collapsed(
                  hintText: "Envie uma mensagem"
              ),
              onChanged: (text) {
                //Se houve uma escrita de alguma msg
                //Se tiver algum texto, está compondo um texto e fica chmando
                // recorrentemente o setState
                setState(() {
                  _isComposing = text.isNotEmpty;
                });
              },
              onSubmitted: (text) {
                //Envio da mensagem escrita
                  widget.sendMessage(text : text);
                  _reset();
              },
            ),
          ),
          IconButton(
              icon: Icon(Icons.send),
              //Se estiver alguma mensagem envia um msg,senao n envia
              onPressed: _isComposing ? () {
                  widget.sendMessage(text : _controller.text);
                  _reset();
              } : null
          ),
        ],
      ),
    );
  }
}
