import 'package:mobx/mobx.dart';

part 'toDo_store.g.dart';

class toDoStore = _toDoStore with _$toDoStore;

abstract class _toDoStore with Store {

  _toDoStore(this.title);

  final String title;

  @observable
  bool done = false;

  @action
  void toggleDone() => done = !done;


}