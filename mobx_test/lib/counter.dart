import 'package:mobx/mobx.dart';

part 'counter.g.dart';//gera outra classe com

class Counter = _Counter with _$Counter;

abstract class _Counter with Store {

  //coloca @observable que transforma em um objeto observado
  @observable
  int count = 0;

  @action
  void increment() {
    count++;
  }

}