// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:get/get.dart';
//import 'package:replica_google_classroom/load_widget.dart';

class UserTypeController extends GetxController {
  static UserTypeController get to => Get.find();

  void abrirTelaDeDados(String tela) {
    Get.toNamed(tela, arguments: [Get.arguments[0],Get.arguments[1],Get.arguments[2]]);
    //Get.toNamed(tela, arguments: ["allan", "millerallan17@gmail.com", 'senha']);
  }
}

class MyWhoAreYouPage extends StatelessWidget {
  MyWhoAreYouPage({Key? key}) : super(key: key);

  final userTypeController = Get.put(UserTypeController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<UserTypeController>(
        init: UserTypeController(),
        builder: (_) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/dataPagebackground.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: double.infinity,
                    height: 300,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 150,
                          decoration: const BoxDecoration(
                            color: Colors.transparent,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Text(
                                  'Bem vindo ao',
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color.fromARGB(255, 0, 0, 0)),
                                ),
                                Image.asset(
                                  'assets/minhaLogo.png',
                                  width: 250,
                                  height: 50,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 0, 0, 8),
                                  child: CustomIconButton(
                                      label: 'Sou ONG',
                                      icon: Transform.scale(
                                          scale: 1.5,
                                          child: const Icon(
                                            Icons.person,
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                          )),
                                      onPressed: () {
                                        userTypeController
                                            .abrirTelaDeDados('dataOngPage');
                                      },
                                      width: 150),
                                ),
                                CustomIconButton(
                                    label: 'Sou usuário',
                                    icon: Transform.scale(
                                        scale: 1.5,
                                        child: const Icon(
                                          Icons.person,
                                          color: Color.fromARGB(
                                              255, 255, 255, 255),
                                        )),
                                    onPressed: () {
                                      userTypeController
                                          .abrirTelaDeDados('/dataPage');
                                    },
                                    width: 150)
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
