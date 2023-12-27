// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';


class AnimalCard extends StatelessWidget {
  final VoidCallback onPressed;
  Map<String,dynamic> pet;
  RxBool preferido = false.obs;
  List<dynamic> petIds;
  String cpf;
  SenhaController senhaController;

  AnimalCard({
    required this.onPressed,
    required this.pet,
    required this.cpf,
    required this.petIds,
    required this.senhaController,
  });

  ImageProvider<Object> convertBase64ToImageProvider(String base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }

  void verificaFavorito(){
    if(petIds.contains(pet['id'])){
      preferido.value = true;
    }
  }



  @override
  Widget build(BuildContext context)  {
    String imagemPadrao = pet['tipo'] == '1' ? 'assets/exemplo1.png': 'assets/exemplo2.png';
    verificaFavorito();
    final imageProvider = pet['imagem'] != null ? convertBase64ToImageProvider(pet['imagem']):AssetImage(imagemPadrao);   
    return Obx(
      () => GestureDetector(
        onTap: onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          child: Container(
            width: 160,
            height: 225,
            decoration: BoxDecoration(
                color:const  Color.fromARGB(255, 255, 250, 248),
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Container(
                      width: 150,
                      height: 120,
                      decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(
                            Radius.circular(15),
                          ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ))),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            pet['nome'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'AsapCondensed-Bold',
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        pet['sexo'] == 'Fêmea'? Icons.male : Icons.female,
                        size: 22,
                        color : pet['sexo'] == 'Fêmea'? const  Color.fromARGB(255, 255, 72, 0) : const   Color.fromARGB(255, 17, 61, 94),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['idade'],
                        style:const  TextStyle(
                          fontSize: 14,
                          fontFamily: 'AsapCondensed-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['raca'],
                        style: const  TextStyle(
                          fontSize: 14,
                          fontFamily: 'AsapCondensed-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async { 
                        preferido.value = !preferido.value;
                        
                        MongoDataBase.favoritaPet(cpf, preferido.value, pet['id']);
                        senhaController.favoritaPet(pet['id'],preferido.value);
                        
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0,0,5,0),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration:  BoxDecoration(
                              color:const  Color.fromARGB(255, 255, 255, 255) ,
                              borderRadius: const  BorderRadius.all(
                                Radius.circular(15),
                              ),
                            image: DecorationImage(image: preferido.value ? const  AssetImage('assets/ame.png'): const AssetImage('assets/ame2.png'),fit: BoxFit.cover)
                            ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
