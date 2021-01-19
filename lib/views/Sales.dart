import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desappega/utils/Configuration.dart';
import 'package:desappega/utils/nav.dart';
import 'package:desappega/views/DetailsSale.dart';
import 'package:desappega/widgets/ItemSale.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desappega/models/Sale.dart';

import '../main.dart';
import 'DrawerList.dart';

class Sales extends StatefulWidget {
  @override
  _SalesState createState() => _SalesState();
}

class _SalesState extends State<Sales> {
  List<String> itensMenu = [];
  List<DropdownMenuItem<String>> _stateListDrop;
  List<DropdownMenuItem<String>> _categoryListDrop;

  final _controller = StreamController<QuerySnapshot>.broadcast();

  String _selectItemState;
  String _selectItemCategory;

  _chooseMenuItem(String itemChosen) {
    switch (itemChosen) {
      case "Meus anúncios":
        Navigator.pushNamed(context, "/my-sales");
        break;
      case "Entrar":
        Navigator.pushNamed(context, "/login");
        break;
      case "Cadastrar":
        Navigator.pushNamed(context, "/register");
        break;
      case "Deslogar":
        _logoutUser();
        break;
    }
  }

  _logoutUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushNamed(context, "/login");
  }

  Future _checkloggeduser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User loggedUser = await auth.currentUser;

    if (loggedUser == null) {
      itensMenu = ["Entrar", "Cadastrar"];
    } else {
      itensMenu = ["Meus anúncios", "Deslogar"];
    }
  }

  _loadsItemsDropDown() {
    //Categorias
    _categoryListDrop = Configuration.getCategories();

    //Estados
    _stateListDrop = Configuration.getStates();
  }

  Future<Stream<QuerySnapshot>> _addListenerSales() async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    Stream<QuerySnapshot> stream = db.collection("sales").snapshots();

    stream.listen((dados) {
      _controller.add(dados);
    });
  }

  Future<Stream<QuerySnapshot>> _filterSales() async {

    FirebaseFirestore db = FirebaseFirestore.instance;

    Query query = db.collection("sales");


    if (_selectItemState != null) {
      query = query.where("state", isEqualTo: _selectItemState);
    }

    if (_selectItemCategory != null) {
      query = query.where("category", isEqualTo: _selectItemCategory);
    }

    Stream<QuerySnapshot> stream = query.snapshots();
    stream.listen((dados){
      _controller.add(dados);
    });

  }

  @override
  void initState() {
    super.initState();

    _checkloggeduser();
    _addListenerSales();
    _loadsItemsDropDown();
  }

  @override
  Widget build(BuildContext context) {
    var uploadData = Center(
      child: Column(children: <Widget>[
        Text("Carregando anúncio"),
        CircularProgressIndicator()
      ],),
    );
    return Scaffold(
      appBar: AppBar(
        title: Text("DESAPPEGA"),
        backgroundColor: (Color(0xff400101)),
        elevation: 0,
      ),
      body: Container(
          child: Column(
        children: <Widget>[
          //Filtros
          Row(
            children: <Widget>[
              Expanded(
                child: DropdownButtonHideUnderline(
                    child: Center(
                  child: DropdownButton(
                    iconEnabledColor: defaultTheme.primaryColor,
                    value: _selectItemState,
                    items: _stateListDrop,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    onChanged: (state) {
                      setState(() {
                        _selectItemState = state;
                        _filterSales();
                      });
                    },
                  ),
                )),
              ),
              Container(
                color: Colors.grey[200],
                width: 2,
                height: 60,
              ),
              Expanded(
                child: DropdownButtonHideUnderline(
                    child: Center(
                  child: DropdownButton(
                    iconEnabledColor: defaultTheme.primaryColor,
                    value: _selectItemCategory,
                    items: _categoryListDrop,
                    style: TextStyle(fontSize: 22, color: Colors.black),
                    onChanged: (category) {
                      setState(() {
                        _selectItemCategory = category;
                        _filterSales();
                      });
                    },
                  ),
                )),
              )
            ],
          ),

          StreamBuilder(
            stream: _controller.stream,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return uploadData;
                case ConnectionState.active:
                case ConnectionState.done:
                  QuerySnapshot querySnapshot = snapshot.data;

                  if (querySnapshot.docs.length == 0) {
                    return Container(
                      padding: EdgeInsets.all(25),
                      child: Text(
                        "Nenhum anúncio! :( ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.builder(
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (_, indice) {
                          List<DocumentSnapshot> sales =
                              querySnapshot.docs.toList();
                          DocumentSnapshot documentSnapshot = sales[indice];
                          Sale sale =
                              Sale.fromDocumentSnapshot(documentSnapshot);

                          return ItemSale(
                            sale: sale,
                            onTapItem: () {
                              push(context, DetailsSale(sale));
                            },
                          );
                        }),
                  );
              }
              return Container();
            },
          )
        ],
      )),
      drawer: DrawerList(),
    );
  }
}
