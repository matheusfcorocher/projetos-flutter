import 'dart:async';
import 'package:rxdart/subjects.dart';

class DrawerBloc {

  final BehaviorSubject<int> _pageController = BehaviorSubject<int>.seeded(0);

  Stream<int> get outPage => _pageController.stream;

  int _page = 0;

  void setPage(int page) {
    if(page == _page)//nao vai para a mesma pagina
      return;
    _page = page;
    _pageController.add(page);
  }

  void dispose() {
    _pageController.close();
  }

}