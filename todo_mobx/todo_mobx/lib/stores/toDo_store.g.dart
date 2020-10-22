// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'toDo_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$toDoStore on _toDoStore, Store {
  final _$doneAtom = Atom(name: '_toDoStore.done');

  @override
  bool get done {
    _$doneAtom.reportRead();
    return super.done;
  }

  @override
  set done(bool value) {
    _$doneAtom.reportWrite(value, super.done, () {
      super.done = value;
    });
  }

  final _$_toDoStoreActionController = ActionController(name: '_toDoStore');

  @override
  void toggleDone() {
    final _$actionInfo =
        _$_toDoStoreActionController.startAction(name: '_toDoStore.toggleDone');
    try {
      return super.toggleDone();
    } finally {
      _$_toDoStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
done: ${done}
    ''';
  }
}
