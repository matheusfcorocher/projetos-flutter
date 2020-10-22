import 'package:xlo/models/adress.dart';

class Ad {

  List<dynamic> images;
  String title;
  String description;
  Address address;
  num price;//num abrange int e double
  bool hidePhone;
  DateTime dateCreated = DateTime.now();

  @override
  String toString() {
    return "$images, $title, $description, $address, $price, $hidePhone";
  }
}