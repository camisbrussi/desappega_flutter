import 'dart:io';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:desappega/utils/Configuration.dart';
import 'package:desappega/utils/UniLabel.dart';
import 'package:desappega/widgets/DividingLine.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:desappega/models/Sale.dart';
import 'package:desappega/widgets/CustomButton.dart';
import 'package:desappega/widgets/CustomInput.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:validadores/Validador.dart';

import '../main.dart';

class NewSale extends StatefulWidget {
  @override
  _NewSaleState createState() => _NewSaleState();
}

class _NewSaleState extends State<NewSale> {
  List<File> _imageList = List();
  List<DropdownMenuItem<String>> _stateListDrop = List();
  List<DropdownMenuItem<String>> _categoryListDrop = List();

  final _formKey = GlobalKey<FormState>();

  Sale _sale;

  BuildContext _dialogContext;

  String _itemSelectedState;
  String _itemSelectedCategory;

  final picker = ImagePicker();



  _openDialog(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(
                  height: 20,
                ),
                Text("Salvando anúncio...")
              ],
            ),
          );
        });
  }

  _salveSale() async {
    _openDialog(_dialogContext);
    //Upload imagens no Storage
    await _uploadImages();

    //Salvar anuncio do Firestore
    FirebaseAuth auth = FirebaseAuth.instance;
    User user = await auth.currentUser;
    String idUserLogged = user.uid;

    print("Acessou SALVAR");

    FirebaseFirestore db = FirebaseFirestore.instance;
    db
        .collection("my_sales")
        .doc(idUserLogged)
        .collection("sales")
        .doc(_sale.id)
        .set(_sale.toMap())
        .then((_) {
      //salvar anúncio público
      db.collection("sales").doc(_sale.id).set(_sale.toMap()).then((_) {
        Navigator.pop(_dialogContext);
        Navigator.pop(context);
      });
    });
  }

  Future _uploadImages() async {
    FirebaseStorage storage = FirebaseStorage.instance;
    Reference root = storage.ref();

    for (var image in _imageList) {
      String imagename = DateTime.now().millisecondsSinceEpoch.toString();
      Reference path = root.child("my_sales").child(_sale.id).child(imagename);

      UploadTask uploadTask = path.putFile(image);
      TaskSnapshot taskSnapshot = await uploadTask;

      String url = await taskSnapshot.ref.getDownloadURL();
      _sale.photos.add(url);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadsItemsDropDown();
    _sale = Sale.generateId();
  }

  _loadsItemsDropDown() {
    //Categorias
    _categoryListDrop = Configuration.getCategories();


    //Estados
    _stateListDrop = Configuration.getStates();

  }

  _onClickImage() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(18.0),
              topRight: Radius.circular(18.0),
            ),
          ),
          padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 50,
                  margin: EdgeInsets.only(bottom: 8),
                  child: DividingLine(),
                ),
                Divider(),
                ListTile(title: UniLabel('Adicionar foto ao produto')),
//                Divider(),
                ListTile(
                  leading: Icon(
                    Icons.camera_alt,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: _onClickCamera,
                  title: Text('Câmera'),
                ),
                ListTile(
                  leading: Icon(
                    Icons.image,
                    color: Theme.of(context).primaryColor,
                  ),
                  trailing: Icon(Icons.chevron_right),
                  onTap: _onClickGallery,
                  title: Text('Galeria'),
                ),
                Divider(),
              ],
            ),
          ),
        );
      },
    );
  }

  _onClickCamera() async {
    Navigator.pop(context);
    File selectimage = await ImagePicker.pickImage(source: ImageSource.camera);
    if (selectimage != null) setState(() { _imageList.add(selectimage);
    });
  }

  _onClickGallery() async {
    Navigator.pop(context);
    File selectimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if (selectimage != null) setState((){_imageList.add(selectimage);
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Novo anúncio"),
          backgroundColor: (Color(0xff400101)),
        ),
        body: SingleChildScrollView(
          child: Container(
            //decoration: BoxDecoration(color: Color(0xffD92525)),
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //área das imagens
                  FormField<List>(
                    initialValue: _imageList,
                    validator: (images) {
                      if (images.length == 0) {
                        return "Necessário selecionar uma imagem!";
                      }
                      return null;
                    },
                    builder: (state) {
                      return Column(
                        children: <Widget>[
                          Container(
                            height: 100,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _imageList.length + 1,
                              itemBuilder: (context, indice) {
                                if (indice == _imageList.length) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                        onTap: () {
                                          _onClickImage();
                                        },
                                        child: CircleAvatar(
                                          backgroundColor: (Color(0xffD9B6A3)),
                                          radius: 50,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.add_a_photo,
                                                size: 40,
                                                color: Colors.grey[100],
                                              ),
                                              Text(
                                                "Adicionar",
                                                style: TextStyle(
                                                    color: Colors.grey[100]),
                                              )
                                            ],
                                          ),
                                        )),
                                  );
                                }
                                if (_imageList.length > 0) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) => Dialog(
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: <Widget>[
                                                        Image.file(
                                                            _imageList[indice]),
                                                        FlatButton(
                                                          child:
                                                              Text("Excluir"),
                                                          textColor: Colors.red,
                                                          onPressed: () {
                                                            setState(() {
                                                              _imageList
                                                                  .removeAt(
                                                                      indice);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                        )
                                                      ],
                                                    ),
                                                  ));
                                        },
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              FileImage(_imageList[indice]),
                                          child: Container(
                                            color: Color.fromRGBO(
                                                255, 255, 255, 0.4),
                                            alignment: Alignment.center,
                                            child: Icon(Icons.auto_delete,
                                                color: Colors.red),
                                          ),
                                        )),
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                          if (state.hasError)
                            Container(
                              child: Text("[${state.errorText}]",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14)),
                            )
                        ],
                      );
                    },
                  ),
                  //Menus Dropdown
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelectedState,
                            hint: Text("Região"),
                            onSaved: (state) {
                              _sale.state = state;
                            },
                            style: TextStyle(
                                color: defaultTheme.primaryColor, fontSize: 20),
                            items: _stateListDrop,
                            validator: (value) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: "Campo obrigatório")
                                  .valido(value);
                            },
                            onChanged: (value) {
                              setState(() {
                                _itemSelectedState = value;
                              });
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.all(8),
                          child: DropdownButtonFormField(
                            value: _itemSelectedCategory,
                            hint: Text("Categoria"),
                            onSaved: (category) {
                              _sale.category = category;
                            },
                            style: TextStyle(
                                color: defaultTheme.primaryColor, fontSize: 20),
                            items: _categoryListDrop,
                            validator: (value) {
                              return Validador()
                                  .add(Validar.OBRIGATORIO,
                                      msg: "Campo obrigatório")
                                  .valido(value);
                            },
                            onChanged: (value) {
                              setState(() {
                                _itemSelectedCategory = value;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  //Caixas de textos e botoes
                  Padding(
                    padding: EdgeInsets.only(bottom: 15, top: 15),
                    child: CustomInput(
                      controller: null,
                      hint: "Título",
                      onSaved: (title) {
                        _sale.title = title;
                      },
                      validator: (value) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomInput(
                      hint: "Preço",
                      onSaved: (price) {
                        _sale.price = price;
                      },
                      type: TextInputType.number,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        RealInputFormatter(centavos: true),
                      ],
                      validator: (value) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(value);
                      },
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomInput(
                      hint: "Telefone",
                      onSaved: (phone) {
                        _sale.phone = phone;
                      },
                      type: TextInputType.phone,
                      inputFormatters: [
                        WhitelistingTextInputFormatter.digitsOnly,
                        TelefoneInputFormatter()
                      ],
                      validator: (value) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .valido(value);
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: 15),
                    child: CustomInput(
                      controller: null,
                      hint: "Descrição (200 caracteres)",
                      onSaved: (description) {
                        _sale.description = description;
                      },
                      maxLines: null,
                      validator: (value) {
                        return Validador()
                            .add(Validar.OBRIGATORIO, msg: "Campo obrigatório")
                            .maxLength(200, msg: "Máximo 200 caracteres")
                            .valido(value);
                      },
                    ),
                  ),
                  CustomButton(
                    text: "Cadastrar Anúncio",
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        //Salva campos
                        _formKey.currentState.save();

                        //Configura o dialog context
                        _dialogContext = context;

                        //salvar anuncio
                        _salveSale();
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
