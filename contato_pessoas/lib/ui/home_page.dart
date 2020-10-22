import 'dart:io';

import 'package:com/helpers/contact_helper.dart';
import 'package:com/ui/contact_page.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

//Enumera constantes para usar mudar a ordem
enum OrderOptions{orderaz, orderza}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  /*Página inicial do app*/

  //Instancializa helper
  //Se instancializar um segundo helper,eles vao referir ao mesmo(static)
  ContactHelper helper = ContactHelper();
  //Cria uma lista de contatos(vazia)
  List<Contact> contacts = List();


  @override
  void initState() {
    super.initState();

    _getAllContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Agenda de Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
        actions: <Widget>[
          PopupMenuButton<OrderOptions>(
            itemBuilder: (context) => <PopupMenuEntry<OrderOptions>>[
              const PopupMenuItem<OrderOptions>(
                  child: Text("Ordenar de A-Z"),
                  value: OrderOptions.orderaz,
              ),
              const PopupMenuItem<OrderOptions>(
                child: Text("Ordenar de Z-A"),
                value: OrderOptions.orderza,
              ),
            ],
            onSelected: _orderList,
      ),
        ],
      ),
      backgroundColor: Colors.white,
      //Cria um botão no canto direito da tela(botao flutuante)
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //Não passa nenhum argumento,pois está criando um novo contato
          _showContactPage();
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
      ),
      body: ListView.builder(
          padding: EdgeInsets.all(10.0),
          itemCount: contacts.length,
          itemBuilder: (context, index) {
              //Cria a lista de visualização das cartas do contato
              return _contactCard(context, index);

          }
      ),
    );
  }

  Widget _contactCard(BuildContext context, int index) {
    /*Função:Criar cada carta de cada contato com foto,nome,email,numero de telefone*/
    return GestureDetector(
      child: Card(
        //Como a classe Card não tem padding, add um filho e coloca um padding
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: <Widget>[
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                      image: contacts[index].img != null ? 
                      FileImage(File(contacts[index].img)):
                          AssetImage("images/person.jpg")
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    //Alinha o texto para esquerda
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(contacts[index].name ?? "",
                          style: TextStyle(
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold
                          ),
                      ),
                      Text(contacts[index].email ?? "",
                        style: TextStyle(
                            fontSize: 18.0,
                        ),
                      ),
                      Text(contacts[index].phone ?? "",
                        style: TextStyle(
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
              ),
            ],
          ),
        ),
      ),
      onTap: () {
        //Vai mostra as opções de ligar para editar,telefonar ou excluir o contato
        _showOptions(context, index);

      },
    );
  }

  void _showOptions(BuildContext context, int index) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
              onClosing: () {},
              builder: (context) {
                return Container(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    //A folha vai ocupar o menor espaço disponível
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.all(10.0),
                          child: FlatButton(
                            child: Text(
                              "Ligar",
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 20.0,
                              ),
                            ),
                            onPressed: () {
                              launch("tel:${contacts[index].phone}");
                              //Fecha a folha de ações
                              Navigator.pop(context);
                            },
                          ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Editar",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () {
                            //Fecha a folha de ações
                            Navigator.pop(context);
                            //Quando dá um tapa para editar contato
                            _showContactPage(contact: contacts[index]);
                          },
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10.0),
                        child: FlatButton(
                          child: Text(
                            "Excluir",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20.0,
                            ),
                          ),
                          onPressed: () {
                            helper.deleteContact(contacts[index].id);
                           setState(() {
                             contacts.removeAt(index);
                             //Fecha a folha de ações
                             Navigator.pop(context);
                           });
                          },
                        ),
                      ),

                    ],
                  ),
                );
              }
          );
        },
    );
  }

  void _showContactPage({Contact contact}) async{
    /*Mostra o contato da pagina principal e da pagina de contato*/
    //Quando usuário voltar para o homepage, a classe Navigator vai retorna
    // um contato, assim é possível salvar
    final recContact = await Navigator.push(
        context, 
        MaterialPageRoute(builder: (context) => ContactPage(contact: contact,))
    );
    if(recContact != null) {
      //Verifica se houve mudanças
      if(contact != null) {
        //Está editando um contato
        await helper.updateContact(recContact);
      }
      else {
        //Criando um novo contato
        await helper.saveContact(recContact);
      }
      await _getAllContacts();
    }
  }

  void _getAllContacts() {
    //atribui a lista de contatos vazia, a lista guardada no contact helper
    helper.getAllContacts().then((list) {
      //Sempre tem que ficar atualizando
      setState(() {
        contacts = list;
      });
    });
  }

  void _orderList(OrderOptions result) {
    /*Função:Ordena a lista de contatos*/
    switch(result) {
      case OrderOptions.orderaz:
        contacts.sort((a, b) {
          //Retorna na ordem a-z(a)
          return a.name.toLowerCase().compareTo(b.name.toLowerCase());
        });
        break;
      case OrderOptions.orderza:
        contacts.sort((a, b) {
          //Retorna na ordem z-a(b)
          return b.name.toLowerCase().compareTo(a.name.toLowerCase());
        });
        break;
    }
    setState(() {

    });
  }

}
