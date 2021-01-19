import 'package:desappega/models/Sale.dart';
import 'package:flutter/material.dart';

class ItemSale extends StatelessWidget {

  Sale sale;
  VoidCallback onTapItem;
  VoidCallback onPressedRemove;

  ItemSale(
  {
    @required this.sale,
    this.onTapItem,
    this.onPressedRemove
});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: this.onTapItem,
      child: Card(
          child: Padding(
              padding: EdgeInsets.all((12)),
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 120,
                    height: 120,
                    child: Image.network(
                      sale.photos[0],
                      fit: BoxFit.cover,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                              sale.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold
                              ),
                          ),
                          Text("R\$ ${sale.price}"),
                        ],
                      ),
                    ),
                  ),
                 if(this.onPressedRemove != null) Expanded(
                    flex: 1,
                    child: FlatButton(
                      color: Colors.red,
                      padding: EdgeInsets.all(10),
                      onPressed: this.onPressedRemove,
                      child: Icon(Icons.delete, color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ))),
    );
  }
}
