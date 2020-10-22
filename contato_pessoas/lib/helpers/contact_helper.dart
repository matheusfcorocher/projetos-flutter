import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:async';

/*Resumo: A classe Contact vai ter a função para acessar e criar um contato
*         A classe ContactHelper tem função de acessar o bd
* */

//Essa variável é o nome do bd
final String contactTable = "contactTable";
//Essas variáveis são os nomes das colunas do bd
final String idColumn = "idColumn";
final String nameColumn = "nameColumn";
final String emailColumn = "emailColumn";
final String phoneColumn = "phoneColumn";
final String imgColumn = "imgColumn";

class ContactHelper {
  /*Essa classe vai apenas ter 1 objeto inteiro(1 instância)
  * O padrão usado será singleton(1 instância)*/

  //static por que 1 instância, criação do construtor interno
  static final ContactHelper _instance = ContactHelper.internal();

  //Consegue acessar a instância da classe com o método ContactHelper()
  factory ContactHelper() => _instance;

  //Chamada do construtor interno
  ContactHelper.internal();

  Database _db;

  Future<Database> get db async {
    /*Apenas o ContactHelper pode acessa o bd
      1-)Se o banco já estiver inicializado
      2-)Se o banco não estiver inicializado,inicializa o bd
      O retorno do método é para retorna um bd do futuro
     */
    if(_db != null) {
      return _db;
    }
    else {
      _db = await initDb();
      return _db;
    }
  }

  Future<Database> initDb() async{
    /*Função:Inicializa o bd,
      1-)acessando o diretório do bd,
      2-)cria uma variável path,
      concatenando o nome do diretório com a string "contacts.db"
      3-)Cria um bd pela 1 vez, como espera para ser criado
      tem que esperar a execução do db, o retorno tem que esperar
      e devolve um bd do futuro
      */

    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "contacts.db");
    
    return await openDatabase(path, version: 1, onCreate: (Database db, int newerVersion) async {
      await db.execute(
        "CREATE TABLE $contactTable"
            "($idColumn INTEGER PRIMARY KEY,"
            "$nameColumn TEXT,"
            "$emailColumn TEXT,"
            "$phoneColumn TEXT,"
            "$imgColumn TEXT)"
      );

    });
  }

  Future<Contact>saveContact(Contact contact) async{
    /*Função:Salva o contato
    * 1-)Obter o bd
    * 2-)Insere no bd o contato como mapa e seleciona o bd e atribui à um id,
    * pois retorna
    *  um id
    * 3-)depois retorna o contato*/
    Database dbContact = await db;
    contact.id = await dbContact.insert(contactTable, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async{
    /*Acessa um contato
    * 1-)Acessa o bd
    * 2-)Cria uma lista de mapas, o qual vai pesquisar do bd,
    * as colunas procuradas e onde idColum é igual ao id do argumento
    * 3-)Verifica se existe 1 contato e retorna ele*/
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(contactTable,
      columns: [idColumn, nameColumn, emailColumn, phoneColumn, imgColumn],
      where: "$idColumn = ?",
      whereArgs: [id]);
      //Usa o = ? no where, devido ao whereArgs substitui por id
    if(maps.length > 0) {
      //Como o bd vai apenas retorna apenas 1 contato, pega o primeiro contato
      //do mapa
      return Contact.fromMap(maps.first);
    }
    else {
      return null;
    }
  }
  
  Future<int> deleteContact(int id) async{
    /*Função: deletar um contato
    * 1-)Recebe o bd
    * 2-)Usa o metodo para deletar a bd(delete)
    * o delete volta um inteiro para mostrar se teve sucesso ou nao
    * por isso que a função retorna um inteiro do futuro*/
    Database dbContact = await db;
    return await dbContact.delete(
        contactTable,
        where: "$idColumn = ?",
        whereArgs: [id]);
  }

  Future<int> updateContact(Contact contact) async{
    /*Função: atualizar um contato
    * 1-)Recebe o bd
    * 2-)Usa o metodo para atualizar a bd(update)
    * o update volta um inteiro para mostrar se teve sucesso ou nao
    * por isso que a função retorna um inteiro do futuro*/
    Database dbContact = await db;
    return await dbContact.update(contactTable,
        contact.toMap(),
        where: "$idColumn = ?",
        whereArgs: [contact.id]);
  }
  
  Future<List> getAllContacts() async{
    /*Retorna todos os contatos*/
    Database dbContact = await db;
    //Lista de mapa na qual recebe todos os mapas do bd
    List listMap = await dbContact.rawQuery("SELECT * FROM $contactTable");
    //Lista de contatos
    List<Contact> listContact = List();
    //Para cada mapa na lista de mapa se transforma em um contato e adicionado a
    //lista de contatos
    for(Map m in listMap) {
      listContact.add(Contact.fromMap(m));
    }
    return listContact;
  }

  Future<int> getNumber() async{
    /*Retorna a quantidade de contatos existentes
    * 1-)Recebe o bd
    * 2-)Retorna um pesquisa bruta no bd usando Count*/
    Database dbContact = await db;
    return Sqflite.firstIntValue(await dbContact.rawQuery("SELECT COUNT(*) FROM $contactTable"));
  }

  Future close() async {
    /*Ele fecha o bd*/
    Database dbContact = await db;
    //Mesmo se retorna um future vazio
    dbContact.close();
  }


}

class Contact {
  /*A classe Contact vai ter a função para acessar e criar um contato
  * */

  //Os atributos da classe
  //O id vai identificar unicamente o usuário
  int id;
  String name;
  String email;
  String phone;
  //Img vai armazena o local da imagem onde ela vai ser salva no dispositivo
  //e não tem tipo para imagem
  String img;

  //Construtor vazio
  Contact();


  Contact.fromMap(Map map) {
    /*O construtor da classe pode ser chamado nomeDaClasse.nomeDoConstrutor,
    Função: vai transforma mapa do bd em contato
    Explicação + detalhada : Quando for armazena os dados dos contatos no bd vai ser em formato de mapa
    e para recuperar os dados do bd precisa ser transformado em mapa*/
      id = map[idColumn];
      name = map[nameColumn];
      email = map[emailColumn];
      phone = map[phoneColumn];
      img = map[imgColumn];
  }

  Map toMap() {
    /*Função:Transforma os dados do contato em um mapa*/
    Map<String, dynamic> map = {
      //não é atribuído o id column,pois o próprio bd faz isso
      // o proprio bd da o valor null se não tiver nenhum item
      nameColumn : name,
      emailColumn : email,
      phoneColumn : phone,
      imgColumn : img
    };
    if(id != null) {
      map[idColumn] = id;
    }
    return map;
  }

  @override
  String toString() {
    //É modifica o toString apenas para mostrar o contato
    // e ficar mais fácil de ler na função main
    return "Contact(id: $id, name:$name, email:$email, phone: $phone, img: $img)";
  }


}