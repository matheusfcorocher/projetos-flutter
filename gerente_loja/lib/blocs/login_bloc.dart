import 'dart:async';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gerente_loja/validators/login_validator.dart';
import 'package:rxdart/rxdart.dart';

enum LoginState {IDLE, LOADING, SUCESS, FAIL}

class LoginBloc extends BlocBase with LoginValidators{

  final _emailController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  final _stateController = BehaviorSubject<LoginState>();

  Stream<String> get outEmail => _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword => _passwordController.stream.transform(validatePassword);
  Stream<LoginState> get outState => _stateController.stream;

  Stream<bool> get outSubmitValid => Observable.combineLatest2(
      outEmail,
      outPassword,
      (a, b) => true
  );
  
  //Essas duas funcoes vao adicionar qualquer entrada do usuario, mudando o valor
  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.add;

  StreamSubscription _streamSubscription;

  LoginBloc() {
    //Usando streamSubscription para que o listener apenas eh usado quando for
    // clickado no botao, senão o listener vai fica capturando ate o fim do app
    // para saber se eh streamSubscription, usa um macete de atribuir para uma String
    // a IDE dá erro ,falando o tipo
    _streamSubscription = FirebaseAuth.instance.onAuthStateChanged.listen((user)
    async {
      if(user != null) {
        if(await verifyPrivileges(user)) {
          _stateController.add(LoginState.SUCESS);
        }
        else {
          FirebaseAuth.instance.signOut();
          _stateController.add(LoginState.FAIL);
        }
      }
      else {
        _stateController.add(LoginState.IDLE);
      }
    });
  }

  void submit() {
    final email = _emailController.value;
    final password = _passwordController.value;

    _stateController.add(LoginState.LOADING);

    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).catchError((error) {
      //Tratamento de excecoes
      _stateController.add(LoginState.FAIL);
    }
    );

  }

  Future<bool> verifyPrivileges(FirebaseUser user) async{
    return await Firestore.instance.collection("admins").document(user.uid).get().then((doc) {
      //Se der erro na autenticacao,data = null, porem conseguiu acha o documento
      if(doc.data != null) {
        //o documento do usuario admin existe
        return true;
      }else {
        return false;
      }
    }).catchError((error) {
      //Caso nao tenha acesso ao administrador
      return false;
    } );
  }

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();

    _streamSubscription.cancel();
  }

}