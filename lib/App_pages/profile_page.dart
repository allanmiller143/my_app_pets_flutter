// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/home_page.dart';
import 'package:replica_google_classroom/App_pages/my_principal_app_page.dart';

class ProfileController extends GetxController {
  static ProfileController get to =>
      Get.find(); // serve para acessar a variável de forma mais simples
  final principalAppPageController = Get.find<PrincipaAppController>();
  var selectedType = '0'.obs;
  List<Map<String, dynamic>> petsInfo = [];
  List<Map<String, dynamic>> petsInfo2 = [];

  void retornaLista() {
    petsInfo = [];
    petsInfo2 = [];

    int tamanhoLista = principalAppPageController.pets.length;
    if (tamanhoLista % 2 != 0) {
      tamanhoLista = tamanhoLista - 1;
    }

    if (tamanhoLista != 0) {
      for (int i = 0; i < tamanhoLista; i++) {
        principalAppPageController.pets[i]['posicao'] = i;
        if (i < tamanhoLista / 2) {
          petsInfo.add(principalAppPageController.pets[i]);
        } else {
          petsInfo2.add(principalAppPageController.pets[i]);
        }
      }
    }
    print(petsInfo);
    print(petsInfo2);
  }

  // Crie uma função para gerar os cards com base nas informações
  List<Widget> generateAnimalCards(petsInfo) {
    List<Widget> cards = [];
    for (var petInfo in petsInfo) {
      cards.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: AnimalCard(
            imagePath: petInfo['imagem'],
            nome: petInfo['nome']!,
            idade: petInfo['idade']!,
            raca: petInfo['raca']!,
            onPressed: () {
              int p = petInfo['posicao'];
              print(p);
              Get.toNamed('/animalDetail',
                  arguments: [principalAppPageController.pets[p]]);
            },
          ),
        ),
      );
    }

    return cards;
  }
}

class ProfilePage extends StatelessWidget {
  ProfilePage({Key? key}) : super(key: key);

  final profileController = Get.put(ProfileController());
  final homePageController = Get.find<
      HomePageController>(); //Obx(() => Text(homePageController.contador.value.toString())),

  @override
  Widget build(BuildContext context) {
    profileController.retornaLista();
    return MaterialApp(
      home: GetBuilder<ProfileController>(
          init: ProfileController(),
          builder: (_) {
            return Scaffold(
                floatingActionButton: FloatingActionButton(
                    onPressed: () {},
                    backgroundColor: Color.fromARGB(255, 255, 51, 0),
                    child: Icon(Icons.filter_alt_outlined)),
                body: Stack(children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Column(
                    children: [
                      Container(
                          margin: EdgeInsets.fromLTRB(25, 0, 25, 15),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15)),
                          child: Column(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Categorias',
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontFamily: 'AsapCondensed-Bold'),
                                    ),
                                  ],
                                ),
                              ),
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    CustomPickPet(
                                        onPressed: () {
                                          profileController.selectedType.value =
                                              '0';
                                        },
                                        imagePath: 'assets/doguinho.png',
                                        tipo: "0",
                                        controller:
                                            profileController.selectedType,
                                        text: 'Cachorros'),
                                    CustomPickPet(
                                        onPressed: () {
                                          profileController.selectedType.value =
                                              '1';
                                        },
                                        imagePath: 'assets/gatinho.png',
                                        tipo: "1",
                                        controller:
                                            profileController.selectedType,
                                        text: 'Gatos'),
                                    CustomPickPet(
                                        onPressed: () {
                                          profileController.selectedType.value =
                                              '2';
                                        },
                                        imagePath: 'assets/passarinho.png',
                                        tipo: "2",
                                        controller:
                                            profileController.selectedType,
                                        text: 'Pássaros'),
                                    CustomPickPet(
                                        onPressed: () {
                                          profileController.selectedType.value =
                                              '3';
                                        },
                                        imagePath: 'assets/outros.png',
                                        tipo: "3",
                                        controller:
                                            profileController.selectedType,
                                        text: 'Todos'),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.64,
                        margin: EdgeInsets.fromLTRB(3, 8, 0, 8),
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    // Use um Container para definir a largura e altura do ScrollView
                                    width:
                                        MediaQuery.of(context).size.width - 6,
                                    height: 490,

                                    child: SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: [
                                              Column(
                                                children: profileController
                                                    .generateAnimalCards(
                                                        profileController
                                                            .petsInfo), // Use a função para gerar os cards
                                              ),
                                              Column(
                                                  children: profileController
                                                      .generateAnimalCards(
                                                          profileController
                                                              .petsInfo2) // Gere mais cards conforme necessáripo
                                                  ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  )
                ]));
          }),
    );
  }
}

class CustomPickPet extends StatelessWidget {
  final VoidCallback onPressed;
  final String tipo;
  final RxString controller;
  final String text;
  final String imagePath;

  CustomPickPet({
    required this.onPressed,
    required this.tipo,
    required this.controller,
    required this.text,
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
      child: GestureDetector(
        onTap: onPressed,
        child: Obx(() {
          final isSelected = controller.value == tipo;
          return Container(
            height: 38,
            decoration: isSelected
                ? BoxDecoration(
                    color: Color.fromARGB(255, 255, 51, 0),
                    borderRadius: BorderRadius.circular(30))
                : BoxDecoration(
                    color: Color.fromARGB(255, 221, 231, 231),
                    borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(3, 0, 2, 0),
              child: Row(
                children: [
                  Container(
                    width: 33,
                    height: 33,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.circular(50),
                      image: DecorationImage(
                        image: AssetImage(imagePath),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 0, 10, 0),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: isSelected
                            ? Color.fromARGB(255, 255, 255, 255)
                            : Color.fromARGB(255, 0, 0, 0),
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class AnimalCard extends StatelessWidget {
  final dynamic imagePath;
  final String nome;
  final String idade;
  final String raca;
  final VoidCallback onPressed;

  AnimalCard({
    required this.imagePath,
    required this.nome,
    required this.idade,
    required this.raca,
    required this.onPressed,
  });


  ImageProvider<Object> convertBase64ToImageProvider(String base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = imagePath != null
        ? convertBase64ToImageProvider(imagePath)
        : AssetImage('assets/exemplo1.png');
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Container(
          width: 160,
          height: 230,
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 250, 248),
              borderRadius: BorderRadius.circular(15)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                child: Container(
                  width: 150,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),)
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          nome,
                          style: TextStyle(
                            fontSize: 22,
                            fontFamily: 'AsapCondensed-Bold',
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ],
                    ),
                    Icon(
                      Icons.male,
                      size: 22,
                      color: Color.fromARGB(255, 255, 72, 0),
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
                      idade,
                      style: TextStyle(
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
                      raca,
                      style: TextStyle(
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
                  Container(
                    width: 55,
                    height: 43,
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 17, 61, 94),
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(15),
                          topLeft: Radius.circular(15),
                        )),
                    child: Icon(
                      Icons.add,
                      color: const Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
