import 'package:cadastro_veiculo/utils/preferences.dart';
import 'package:flutter/material.dart';

class Empresas{

  static List<DropdownMenuItem<String>> getEmpresas() {
    List<DropdownMenuItem<String>> empresas = [];

    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("GE"),
        ],
      ),
      value: "GE",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("STEAG"),
        ],
      ),
      value: "STEAG",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("MT"),
        ],
      ),
      value: "MT",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("QAP"),
        ],
      ),
      value: "QAP",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("OMEGA"),
        ],
      ),
      value: "OMEGA",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("J&R"),
        ],
      ),
      value: "J&R",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(
            Icons.work,
            color: corAzulEscuro,
          ),
          SizedBox(
            width: 15,
          ),
          Text("FLEX WIND"),
        ],
      ),
      value: "FLEX WIND",
    ));
    empresas.add(new DropdownMenuItem(
      child: Row(
        children: [
          Icon(Icons.linear_scale, color: corAzulEscuro),
          SizedBox(
            width: 15,
          ),
          Text("OUTROS"),
        ],
      ),
      value: "OUTROS",
    ));

    
    return empresas;
  }
}