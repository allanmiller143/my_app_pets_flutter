// ignore_for_file: prefer_const_literals_to_create_immutables, avoid_print

import 'package:flutter/material.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:get/get.dart';
//import 'package:replica_google_classroom/load_widget.dart';

class UserTypeController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;

  @override
  void onInit() {
    meuControllerGlobal = Get.find();
    super.onInit();
  }

  void abrirTelaDeDados(String tela) {
    Get.toNamed('/dataOngPage');
  }
}

class MyWhoAreYouPage extends StatelessWidget {
  MyWhoAreYouPage({super.key});

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
                  child: SizedBox(
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
                                  padding:const EdgeInsets.fromLTRB(0, 0, 0, 8), 
                                  child: CustomIconButton(
                                    label: 'Sou ONG',
                                   
                                      onPressed: () {
                                      userTypeController.abrirTelaDeDados('dataOngPage');    
                                    },
                                    width: 200,
                                    alinhamento: MainAxisAlignment.center,
                                    ),
                                ),
                                CustomIconButton(
                                  label: 'Sou usuário',
                                  
                                      onPressed: () async {
                                        dynamic info = {
                                          'Tipo': "comum",
                                          'Pets preferidos': [],
                                          'Data': false
                                        };
                                        userTypeController.meuControllerGlobal.usuario.addAll(info);                                   
                                        await BancoDeDados.adicionarInformacoesUsuario(info, userTypeController.meuControllerGlobal.usuario['Id']);
                                        userTypeController.meuControllerGlobal.petsSistema = await BancoDeDados.obterPets();


                                        Get.toNamed('/principalAppPage');
                                        //userTypeController.abrirTelaDeDados('/');    
                                    },
                                  width: 200,
                                  alinhamento: MainAxisAlignment.center,
                                  )
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
