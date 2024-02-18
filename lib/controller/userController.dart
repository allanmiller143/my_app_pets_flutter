// ignore_for_file: avoid_print

import 'package:get/get.dart';
class MeuControllerGlobal extends GetxController {

  late List<Map<String,dynamic>> petsSistema = [];
  var pets = [];
  var imagensFeed = [];
  late Map<String,dynamic> usuario;
  double tamanhoTela = 0;
  RxBool internet = true.obs;
  late String token;

  void favoritaPet(idPet,preferido){
    if(preferido){
      usuario['Pets preferidos'].add(idPet);
    }
    else{
      usuario['Pets preferidos'].remove(idPet);  
    }
  }

  void limparTudo(){
    pets = [];
    imagensFeed = [];
    usuario = {};
  }
  


}