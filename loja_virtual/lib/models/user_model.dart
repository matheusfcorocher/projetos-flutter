import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model{
  /*Model é usado para que em t odo o app seja modificado
  (modificado todos os estados), exemplo, se a pessoa muda o nome, muda o nome
  em todas as outras paginas
  *O model é um objeto que vai guarda os estados de alguma coisa
  (nesse caso o estado de login do app)
  Ele vai ter o estado e as funções que vai modificado o estado
  Quando você muda o estado, influencia no app inteiro
  * */

  //usuario atual

  @override
  void addListener(VoidCallback listener) {
    //Quando inicializar ja mostra o usuario
    super.addListener(listener);

    _loadCurrentUser();
  }

  //autenticador
  FirebaseAuth _auth = FirebaseAuth.instance;

  //essa variavel vai conter alguns info basica do user
  FirebaseUser firebaseUser;
  //Mapa contendo nome,email e o endereco do usuario(campos importantes)
  Map<String, dynamic> userData = Map();

  //essa variavel tem o intuito de mostrar se o usuario esta
  // carregando alguma coisa
  bool isLoading = false;

  //retorna o userModel para ser acessado apenas usando UserModel.of(context)
  static UserModel of(BuildContext context) => ScopedModel.of<UserModel>(context);


  void signUp({@required Map<String, dynamic> userData, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFail}) {
    //VoidCallBack eh uma função que vai ser passada e sera usada dentro da funcao
    //Os parametros se tornaram opcionais, porem o @required obriga ter os argumentos requiridos
    isLoading = true;
    notifyListeners();

    //Vai criar o usuario no firebase, como retorna um futuro, depois de ter registrado
    //ele vai passar por outra transformacao usando .then e passando o usuario
    //se der algum erro(ja estiver um usuario registrado com o mesmo email),
    // ele dara um erro
    _auth.createUserWithEmailAndPassword(
        email: userData["email"],
        password: pass
    ).then((user) async{
      firebaseUser = user;

      //Salva manualmente o endereco do usuario
      await _saveUserData(userData);

      //Se deu sucesso chama a funcao onSucess
      onSucess();
      isLoading = false;
      notifyListeners();
    }).catchError((e) {
      //Se der algum erro chama a funcao onFail
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signIn({@required String email, @required String pass, @required VoidCallback onSucess, @required VoidCallback onFail}) async{
   /*Mostra que esta carregando, notifica para todos que esta carregando e espera 3 segundos
   * e coloca a variavel isLoading como falsa
   * Ver : Quando o usuario tentar entrar sem login , ele vai esperar e volta para tela de login
   * */
    isLoading = true;
    notifyListeners();
    
    _auth.signInWithEmailAndPassword(
        email: email,
        password: pass
    ).then((user) async{
      firebaseUser = user;

      await _loadCurrentUser();

      onSucess();
      isLoading = false;
      notifyListeners();

    }).catchError((e) {
      onFail();
      isLoading = false;
      notifyListeners();
    });
  }

  void signOut() async{
    /*Sai do usuario*/
    await _auth.signOut();

    //reseta o userData
    userData = Map();
    //reseta o firebaseUser
    firebaseUser = null;

    notifyListeners();
  }

  void recoverPass(String email) {
    //chama o autenticador para resetar o email
    _auth.sendPasswordResetEmail(email: email);

  }

  bool isLoggedIn() {
    /*Mostra se tem usuario no firebase*/
    return firebaseUser != null;
  }

  Future<Null> _saveUserData(Map<String, dynamic> userData) async {
    //Salva o usuario no firestore
    //principalmente o endereco
    this.userData = userData;
    await Firestore.instance.collection("users").document(firebaseUser.uid).setData(userData);
  }

  Future<Null> _loadCurrentUser() async {
    /*Carrega o usuario do bd no firebase no app*/

    //Se a variavel firebaseUser estiver vazia, ele autentica
    if(firebaseUser == null)
      firebaseUser = await _auth.currentUser();
    else {
      if(userData["name"] == null) {
        DocumentSnapshot docUser = await Firestore.
        instance.collection("users").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
  }



}