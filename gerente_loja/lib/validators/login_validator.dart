import 'dart:async';

class LoginValidators {
  //Essa classe representa um transformador do dado
  // antes de enviar para o fim do tubo do login, nesse caso a transformacao eh
  // validacao

  //Vai entrar com String e vai sair Com String
  final validateEmail = StreamTransformer<String , String>.fromHandlers(
    handleData: (email, sink) {
      if(email.contains("@")) {
        sink.add(email);
      }
      else {
        sink.addError("Insira um e-mail valido");
      }
    }
  );
  
  final validatePassword = StreamTransformer<String, String>.fromHandlers(
    handleData: (password, sink) {
      if(password.length > 4) {
        sink.add(password);
      }
      else {
        sink.addError("Insira uma senha com mais de 4 caracteres");
      }
    }
  );

}