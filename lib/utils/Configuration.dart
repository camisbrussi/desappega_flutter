import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Configuration {
  static List<DropdownMenuItem<String>> getStates() {
    List<DropdownMenuItem<String>> dropStatesItems = [];

    //Estados
    dropStatesItems.add(
        DropdownMenuItem(child: Text(
        "Região", style: TextStyle(
          color: defaultTheme.primaryColor,
        ),
      ),
      value: null,
    ));

    for (var state in Estados.listaEstadosAbrv) {
      dropStatesItems.add(DropdownMenuItem(
        child: Text(state),
        value: state,
      ));
    }

    return dropStatesItems;
  }

  static List<DropdownMenuItem<String>> getCategories() {
    List<DropdownMenuItem<String>> dropCategoryItems = [];


    //Categorias
    dropCategoryItems.add(DropdownMenuItem(
      child: Text(
        "Categoria",
        style: TextStyle(
          color: defaultTheme.primaryColor,
        ),
      ),
      value: null,
    ));

    dropCategoryItems.add(DropdownMenuItem(
      child: Text("Roupas"),
      value: "roupas",
    ));

    dropCategoryItems.add(DropdownMenuItem(
      child: Text("Autómovel"),
      value: "auto",
    ));

    dropCategoryItems.add(DropdownMenuItem(
      child: Text("Eletrônicos"),
      value: "eletro",
    ));

    dropCategoryItems.add(DropdownMenuItem(
      child: Text("Móveis"),
      value: "moveis",
    ));
    return dropCategoryItems;
  }
}
