import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:todomobx/stores/list_store.dart';
import 'package:todomobx/stores/login_store.dart';
import 'package:todomobx/widgets/custom_icon_button.dart';
import 'package:todomobx/widgets/custom_text_field.dart';

import 'login_screen.dart';

class ListScreen extends StatefulWidget {

  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {

  final ListStore listStore = ListStore();

  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Container(
          margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Tarefas',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 32
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.exit_to_app),
                      color: Colors.white,
                      onPressed: (){
                        //como a acao so executa uma 1 vez, nao precisa ficar sendo ouvido, por isso que coloca listen = false
                        Provider.of<LoginStore>(context, listen: false).logout();
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context)=>LoginScreen())
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 16,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: <Widget>[
                        Observer(
                            builder: (_) {
                              return CustomTextField(
                                controller: controller,
                                hint: 'Tarefa',
                                onChanged: listStore.setNewTodoTitle,
                                suffix: listStore.isTitleValid ? CustomIconButton(
                                  radius: 32,
                                  iconData: Icons.add,
                                  onTap: () {
                                    listStore.addTodo();
                                    controller.clear();
                                  },
                                ) : null,
                              );
                            }
                        ),
                        const SizedBox(height: 8,),
                        Expanded(
                          child: Observer(
                              builder: (_) {
                                return ListView.separated(
                                  itemCount: listStore.toDoList.length,
                                  itemBuilder: (_, index){
                                    final toDo = listStore.toDoList[index];
                                    return Observer(
                                        builder: (_) {
                                          return ListTile(
                                            title: Text(
                                              toDo.title,
                                              style: TextStyle(
                                                decoration:  toDo.done ?
                                                    TextDecoration.lineThrough : null,
                                                color: toDo.done ?
                                                    Colors.grey : Colors.black
                                              ),
                                            ),
                                            onTap: toDo.toggleDone,
                                          );
                                        }
                                    );
                                  },
                                  separatorBuilder: (_, __){
                                    return Divider();
                                  },
                                );
                              }
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}