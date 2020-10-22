import 'package:rxdart/rxdart.dart';
import 'package:xlo/models/ad.dart';

enum CreateState { IDLE, LOADING, DONE }

class CreateBloc {

  final BehaviorSubject<CreateState> _createStateController =
    BehaviorSubject<CreateState>.seeded(CreateState.IDLE);

  Stream<CreateState> get outCreate => _createStateController.stream;

  Future<bool> saveAd(Ad ad) async {
    _createStateController.add(CreateState.LOADING);

    // mandar o ad pro repositorio
    await Future.delayed(Duration(seconds: 3));

    _createStateController.add(CreateState.DONE);

    return true;

  }

  void dispose() {
    _createStateController.close();
  }

}