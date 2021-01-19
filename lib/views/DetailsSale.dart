import 'package:carousel_pro/carousel_pro.dart';
import 'package:desappega/main.dart';
import 'package:desappega/models/Sale.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailsSale extends StatefulWidget {
  Sale sale;
  DetailsSale(this.sale);

  @override
  _DetailsSaleState createState() => _DetailsSaleState();
}

class _DetailsSaleState extends State<DetailsSale> {
  Sale _sale;
  List<Widget> _getImagesList() {
    List<String> listUrlImages = _sale.photos;

    return listUrlImages.map((url) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
            image: DecorationImage(
          image: NetworkImage(url),
        )),
      );
    }).toList();
  }

  _callphone(String phone) async {
    if (await canLaunch("tel:$phone")) {
      await launch("tel:$phone");
    } else {
      print("Não pode fazer a ligação");
    }
  }

  @override
  void initState() {
    super.initState();
    _sale = widget.sale;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Anuncio"),
          backgroundColor: (Color(0xff400101)),
        ),
        body: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                SizedBox(
                  height: 250,
                  child: Carousel(
                    images: _getImagesList(),
                    dotSize: 8,
                    dotBgColor: Colors.transparent,
                    dotColor: Colors.white,
                    autoplay: false,
                    dotIncreasedColor: defaultTheme.primaryColor,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "R\$ ${_sale.price}",
                        style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: defaultTheme.primaryColor),
                      ),
                      Text(
                        "${_sale.title}",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.w400),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      Text(
                        "Descrição",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "${_sale.description}",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Divider(),
                      ),
                      Text(
                        "Contato",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(bottom: 66),
                        child: Text(
                          "${_sale.phone}",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: GestureDetector(
                child: Container(
                  child: Text(
                    "Comprar",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                  padding: EdgeInsets.all(16),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: defaultTheme.primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                ),
                onTap: () {
                  _callphone(_sale.phone);
                },
              ),
            )
          ],
        ));
  }
}
