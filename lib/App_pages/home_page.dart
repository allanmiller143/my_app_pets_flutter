// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:replica_google_classroom/App_pages/my_principal_app_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class HomePageController extends GetxController {
  static HomePageController get to =>
      Get.find(); // serve para acessar a variável de forma mais simples
  final principalAppPageController = Get.find<PrincipaAppController>();
}

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final homePageController = Get.put(HomePageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<HomePageController>(
        init: HomePageController(),
        builder: (_) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.fromLTRB(15, 22, 15, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Seja bem-vindo!',
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'ArefRuqaa-Regular',
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 160,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: DecorationImage(
                        image: AssetImage('assets/banner2.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 13),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'Categorias',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'AsapCondensed-Bold'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomCard(
                              onPressed: () async {},
                              imagePath: 'assets/doguinho.png',
                              text: 'Cachorros',
                              backgroundImageColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                              containerColor:
                                  const Color.fromARGB(255, 255, 81, 0),
                              textColor:
                                  const Color.fromARGB(255, 255, 255, 255),
                            ),
                            CustomCard(
                              onPressed: () {
                                print('gatinho');
                              },
                              imagePath: 'assets/gatinho.png',
                              text: 'Gatos',
                            ),
                            CustomCard(
                              onPressed: () {
                                print('passaros');
                              },
                              imagePath: 'assets/passarinho.png',
                              text: 'Pássaros',
                            ),
                            CustomCard(
                              onPressed: () {
                                print('outros');
                              },
                              imagePath: 'assets/outros.png',
                              text: 'Outros',
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Veja todos',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontFamily: 'AsapCondensed-Light'),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: double.infinity,
                        height: 180,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: [
                            AnimalCard(
                              imagePath: homePageController
                                  .principalAppPageController.pets[0]['imagem'],
                              name: homePageController
                                  .principalAppPageController.pets[0]['nome'],
                              raca: homePageController
                                  .principalAppPageController.pets[0]['raca'],
                              sexo: homePageController
                                  .principalAppPageController.pets[0]['sexo'],
                              onPressed: () {
                                Get.toNamed('/animalDetail', arguments: [
                                  homePageController
                                      .principalAppPageController.pets[0]
                                ]);
                              },
                            ),
                            AnimalCard(
                              imagePath: homePageController
                                  .principalAppPageController.pets[1]['imagem'],
                              name: homePageController
                                  .principalAppPageController.pets[1]['nome'],
                              raca: homePageController
                                  .principalAppPageController.pets[1]['raca'],
                              sexo: homePageController
                                  .principalAppPageController.pets[1]['sexo'],
                              onPressed: () {
                                Get.toNamed('/animalDetail', arguments: [
                                  homePageController
                                      .principalAppPageController.pets[1]
                                ]);
                              },
                            ),
                            AnimalCard(
                              imagePath: homePageController
                                  .principalAppPageController.pets[2]['imagem'],
                              name: homePageController
                                  .principalAppPageController.pets[2]['nome'],
                              raca: homePageController
                                  .principalAppPageController.pets[2]['raca'],
                              sexo: homePageController
                                  .principalAppPageController.pets[2]['sexo'],
                              onPressed: () {
                                Get.toNamed('/animalDetail', arguments: [
                                  homePageController
                                      .principalAppPageController.pets[2]
                                ]);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String text;
  final Color containerColor;
  final Color textColor;
  final Color backgroundImageColor;

  CustomCard({
    required this.onPressed,
    required this.imagePath,
    required this.text,
    this.containerColor = const Color.fromARGB(255, 255, 255, 255),
    this.textColor = Colors.black,
    this.backgroundImageColor = const Color.fromARGB(255, 255, 81, 0),
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          width: 60,
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: containerColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundImageColor,
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontFamily: 'AsapCondensed-Light',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class AnimalCard extends StatelessWidget {
  final dynamic imagePath;
  final String name;
  final String raca;
  final String sexo;
  final VoidCallback onPressed;

  AnimalCard({
    required this.imagePath,
    required this.name,
    required this.raca,
    required this.sexo,
    required this.onPressed,
  });

  ImageProvider<Object> convertBase64ToImageProvider(String base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context) {
    var imagem;
    sexo == 'Macho' ? imagem = 'assets/model1.png' : imagem = 'assets/model2.png';

    final imageProvider = imagePath != null
        ? convertBase64ToImageProvider(imagePath)
        : AssetImage(imagem);
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 8,
        child: Container(
          width: 140, // Ajuste a largura conforme necessário
          decoration: BoxDecoration(
              color: Color.fromARGB(255, 252, 255, 255),
              borderRadius: BorderRadius.circular(20)),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                child: Container(
                    width: 130,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          name,
                          style: TextStyle(
                            fontSize: 15,
                            fontFamily: 'AsapCondensed-medium',
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                        Icon(
                          sexo == 'Macho' ? Icons.male : Icons.female,
                          size: 14,
                          color: const Color.fromARGB(255, 0, 0, 0),
                        )
                      ],
                    ),
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/coracao.png'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 4, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      raca,
                      style: TextStyle(
                        fontSize: 10,
                        fontFamily: 'AsapCondensed-Light',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
