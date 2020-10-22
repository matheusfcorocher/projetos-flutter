import 'package:rxdart/subjects.dart';
import 'package:xlo/models/ad.dart';

class HomeBloc {

  final BehaviorSubject<String> _searchController = BehaviorSubject<String>();
  final BehaviorSubject<List<Ad>> _adsController = BehaviorSubject<List<Ad>>
      .seeded( [] );

  Stream<String> get outSearch => _searchController.stream;
  Stream<List<Ad>> get outAds => _adsController.stream;

  void addAds(Ad new_ad) {
    _adsController.add(_adsController.value..add(new_ad));
  }

  void setSearch(String search) {
    _searchController.add(search);
  }

  void dispose() {
    _searchController.close();
    _adsController.close();
  }

}