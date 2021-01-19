import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desappega/utils/nav.dart';
import 'package:desappega/views/NewSale.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:desappega/models/Sale.dart';
import 'package:desappega/widgets/ItemSale.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class MySales extends StatefulWidget {
  @override
  _MySalesState createState() => _MySalesState();
}

class _MySalesState extends State<MySales> {
  final _controller = StreamController<QuerySnapshot>.broadcast();
  String _idUserLogged;

  _recoverDataLoggedUser() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    _idUserLogged = user.uid;
  }

  Future<Stream<QuerySnapshot>> _addListenerSales() async {
    await _recoverDataLoggedUser();

    FirebaseFirestore db = FirebaseFirestore.instance;

    Stream<QuerySnapshot> stream = db
        .collection("my_sales")
        .doc(_idUserLogged)
        .collection("sales")
        .snapshots();

    stream.listen((datas) {
      _controller.add(datas);
    });
  }

  _removeSale(String idSale) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("my_sales")
        .doc(_idUserLogged)
        .collection("sales")
        .doc(idSale)
        .delete().then((_){

          db.collection("sales")
              .doc( idSale )
              .delete();
    });
  }

  @override
  void initState() {
    super.initState();
    _addListenerSales();
  }

  @override
  Widget build(BuildContext context) {
    var loadData = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text("Carregando anúncios"),
          CircularProgressIndicator()
        ],
      ),
    );
    return Scaffold(
        appBar: AppBar(
          title: Text("Meus anúncios"),
          backgroundColor: (Color(0xff400101)),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          foregroundColor: Colors.white,
          backgroundColor: defaultTheme.primaryColor,
          icon: Icon(Icons.add),
          label: Text("Adicionar"),
          onPressed: () {
            push(context, NewSale());
          },
        ),
        body: StreamBuilder(
          stream: _controller.stream,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return loadData;
                break;
              case ConnectionState.active:
              case ConnectionState.done:
                //Exibir imagem de erro
                if (snapshot.hasError) return Text("Erro a carregador dados!");

                QuerySnapshot querySnapshot = snapshot.data;

                return ListView.builder(
                    itemCount: querySnapshot.docs.length,
                    itemBuilder: (_, indice) {
                      List<DocumentSnapshot> sales =
                          querySnapshot.docs.toList();
                      DocumentSnapshot documentSnapshot = sales[indice];
                      Sale sale = Sale.fromDocumentSnapshot(documentSnapshot);

                      return ItemSale(
                        sale: sale,
                        onPressedRemove: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Confirmar"),
                                  content: Text(
                                      "Deseja realmente excluir o anúncio?"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text(
                                        "Cancelar",
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    FlatButton(
                                      color: Colors.red,
                                      child: Text(
                                        "Remover",
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _removeSale(sale.id);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                );
                              });
                        },
                      );
                    });
            }
            return Container();
          },
        ));
  }
}
