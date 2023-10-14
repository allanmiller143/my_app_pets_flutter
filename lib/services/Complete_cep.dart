// ignore_for_file: avoid_print

import 'dart:convert';

import 'package:http/http.dart' as http;
//import 'dart:convert';

Future<Map<String, dynamic>> buscaCep(String cep) async {
  
  final url = Uri.parse(
      'https://viacep.com.br/ws/$cep/json/'); // passo 1 - difinir a url de dados

  http.Response response; //passo 2 - armazenar a resposta da requisição

  response = await http.get(url); //passo 3 efetar a requisição

  print("Resposta: ${response.body}"); // verificar a resposta
  print("statusCode: ${response.statusCode.toString()}");

  Map<String, dynamic> dados = {};
  if (response.statusCode == 200) {
    // manipular os dados que estao em formato de json.
    dados = json.decode(response.body);
  }
  return dados;
}
