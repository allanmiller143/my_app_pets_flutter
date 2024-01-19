import 'dart:io';

import 'package:random_string/random_string.dart';

class Animal {
  String tipo;
  String nome;
  String idade;
  String porte;
  String raca;
  String sexo;


  Animal({
    required this.tipo,
    required this.nome,
    required this.idade,
    required this.porte,
    required this.raca,
    required this.sexo,
  });

  Map<String, dynamic> toMap() {
    String id = randomAlphaNumeric(10);
    return {
      "Id" : id,
      "Tipo": tipo,
      "Nome": nome,
      "Idade": idade,
      "Sexo": sexo,
      "Porte": porte,
      "Raça": raca,
    };
  }

  bool validarCampo(String campo, String valor) {
    if (campo == valor) {
      return false;
    }
    return true;
  }

  String validaCampos() {
    List<String> camposInvalidos = [];

    if (!validarCampo('Raça', raca)) {
      camposInvalidos.add('Raça\n');
    }
    if (!validarCampo('Sexo', sexo)) {
      camposInvalidos.add('Sexo\n');
    }

    if (!validarCampo('Porte', porte)) {
      camposInvalidos.add('Porte\n');
    }

    if (!validarCampo('0', tipo)) {
      camposInvalidos.add('Tipo\n');
    }

    if (!validarCampo('Idade', idade)) {
      camposInvalidos.add("Idade\n");
    }

    if (nome.isEmpty) {
      camposInvalidos.add("Nome\n");
    }

    if (camposInvalidos.isNotEmpty) {
      return 'Insira os campos:\n${camposInvalidos.join("")}';
    }

    return '';
  }
}
