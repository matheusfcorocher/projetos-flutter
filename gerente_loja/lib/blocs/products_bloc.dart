import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:rxdart/rxdart.dart';

class ProductBloc extends BlocBase {

  final _dataController = BehaviorSubject<Map>();
  final _loadingController = BehaviorSubject<bool>();
  final _createdController = BehaviorSubject<bool>();

  Stream<Map> get OutData => _dataController.stream;
  Stream<bool> get outLoading => _loadingController.stream;
  Stream<bool> get outCreated => _createdController.stream;

  String categoryId;
  DocumentSnapshot product;

  Map<String, dynamic> unsavedData;

  ProductBloc({this.categoryId, this.product}) {
    if(product != null) {
      unsavedData = Map.of(product.data);
      //sobrescreve images como uma lista de imagens para poder se expandir
      unsavedData['images'] = List.of(product.data['images']);
      unsavedData['sizes'] = List.of(product.data['sizes']);//cria uma lista

      _createdController.add(true);
    } else {
      unsavedData = {
        'title': null,
        'description' : null,
        'price' : null,
        'images' : [],
        'sizes' : []
      };

      _createdController.add(false);
    }

    _dataController.add(unsavedData);
  }

  void saveTitle(String title) {
    unsavedData['title'] = title;
  }

  void saveDescription(String description) {
    unsavedData['description'] = description;
  }

  void savePrice(String price) {
    unsavedData['price'] = double.parse(price);
  }

  void saveImages(List images) {
    unsavedData['images'] = images;
  }

  void saveSizes(List sizes) {
    unsavedData['sizes'] = sizes;
  }

  Future<bool> saveProduct() async{
    _loadingController.add(true);
    try {
      if(product != null) {
        await _uploadImages(product.documentID);
        await product.reference.updateData(unsavedData);
      }else {
        DocumentReference dr = await Firestore.instance.collection('products').
        document(categoryId).collection('itens').add(Map.from(unsavedData)
          ..remove('images'));
        await _uploadImages(dr.documentID);
        await dr.updateData(unsavedData);

      }

      _createdController.add(true);
      _loadingController.add(false);
      return true;
    }
    catch (e){
      _loadingController.add(false);
      return false;
    }
  }

  Future _uploadImages(String productId) async {
    for(int i = 0; i< unsavedData['images'].length; i++) {
      if(unsavedData['images'][i] is String)
        continue;

      StorageUploadTask uploadTask = FirebaseStorage.instance.ref().child(categoryId).
      child(productId).child(DateTime.now().millisecondsSinceEpoch.toString())
          .putFile(unsavedData['images'][i]);

      StorageTaskSnapshot s = await uploadTask.onComplete;
      String downloadUrl = await s.ref.getDownloadURL();

      unsavedData['images'][i] = downloadUrl;

    }
  }

  void deleteProduct() {
    product.reference.delete();
  }

  @override
  void dispose() {
    _dataController.close();
    _loadingController.close();
    _createdController.close();
  }


}