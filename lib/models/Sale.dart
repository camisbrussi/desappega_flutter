
import 'package:cloud_firestore/cloud_firestore.dart';

class Sale{

  String _id;
  String _state;
  String _category;
  String _title;
  String _price;
  String _phone;
  String _description;
  List<String> _photos;

  Sale();

  Sale.fromDocumentSnapshot(DocumentSnapshot documentSnapshot){
    this.id = documentSnapshot.id;
    this.state = documentSnapshot["state"];
    this.category = documentSnapshot["category"];
    this.title = documentSnapshot["title"];
    this.price = documentSnapshot["price"];
    this.phone = documentSnapshot["phone"];
    this.description = documentSnapshot["description"];
    this.photos = List<String>.from(documentSnapshot["photos"]);

  }

  Sale.generateId(){

    FirebaseFirestore db = FirebaseFirestore.instance;

    CollectionReference sale = db.collection("my_sales");
    this.id = sale.doc().id;

    this.photos = [];

  }

  Map<String, dynamic> toMap(){

    Map<String, dynamic> map = {
      "id" : this.id,
      "state" : this.state,
      "category" : this.category,
      "title" : this.title,
      "price" : this.price,
      "phone" : this.phone,
      "description" : this.description,
      "photos" : this.photos,
    };

    return map;

  }

  List<String> get photos => _photos;

  set photos(List<String> value) {
    _photos = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
  }

  String get price => _price;

  set price(String value) {
    _price = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get category => _category;

  set category(String value) {
    _category = value;
  }

  String get state => _state;

  set state(String value) {
    _state = value;
  }

  String get id => _id;

  set id(String value) {
    _id = value;
  }
}