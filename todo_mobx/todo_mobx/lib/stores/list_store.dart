import 'package:mobx/mobx.dart';
import 'package:todomobx/stores/toDo_store.dart';

part 'list_store.g.dart';

class ListStore = _ListStore with _$ListStore;

abstract class _ListStore with Store {

  @observable
  String newTodoTitle = '';

  @action
  void setNewTodoTitle(String value) => newTodoTitle = value;

  @computed
  bool get isTitleValid => newTodoTitle.isNotEmpty;

  //Usa ObservableList para nao ficar recriando a lista
  @observable
  ObservableList<toDoStore> toDoList = ObservableList();

  @action
  void addTodo() {
    toDoList.insert(0, toDoStore(newTodoTitle));
    newTodoTitle = '';
  }

  //Representa uma forma de adicionar a lista
  /*@observable
  List<String> toDoList = [];

  @action
  void addTodo() {
    toDoList = List.from(toDoList..add(newTodoTitle));
    //para seguir o triangulo do mobx, precisa ser recriado a lista toda vez, para
    //adicionar um widget na tela list_screen, pois a lista apenas esta acrescentando
    //dados e nao esta mudando de estado. Para muda de estado recria a lista toda vez
  }*/
}