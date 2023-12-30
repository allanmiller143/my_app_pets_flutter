// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/insert_animal_page.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';


class PrincipalOngAppController extends GetxController {
  late SenhaController senhaController;
  var opcaoSelecionada = 0.obs;
  Color corItemSelecionado = const Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = const  Color.fromARGB(255, 255, 255, 255);
  late String emailUsuario;
  File? imageFile;
  File? imageFeedFile;
  Map<String,dynamic>? usuario;

  Future<String> func() async{
    senhaController = Get.find(); // Encontra a instância existente
    emailUsuario = senhaController.email;
    return 'allan';
  }

  void mudaOpcaoSelecionada(int index) {
    opcaoSelecionada.value = index;
  }

}


class MyPrincipalOngAppPage extends StatelessWidget {
  const MyPrincipalOngAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    var principalOngAppController = PrincipalOngAppController();
    return MaterialApp(
      home: GetBuilder<PrincipalOngAppController>(
          init: PrincipalOngAppController(),
          builder: (_) {
            return Scaffold(
              extendBodyBehindAppBar: true,
            
              appBar: AppBar(
                forceMaterialTransparency: true,
                toolbarHeight: 85,
              ),
              bottomNavigationBar: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 0.1, color: Colors.black))),    
                  child: BottomNavigationBar(
                    elevation: 8,
                    onTap: (index) {
                      principalOngAppController.mudaOpcaoSelecionada(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    currentIndex: principalOngAppController.opcaoSelecionada.value,
                    backgroundColor:const  Color.fromARGB(255, 255, 51, 0),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Casa',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.pets_outlined),
                        label: 'Inserir',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Perfil',
                      ),
                    ],
                    selectedItemColor: principalOngAppController.corItemSelecionado,
                    unselectedItemColor:principalOngAppController.corItemNaoSelecionado,
                  ),
                ),
              ),

              body: FutureBuilder(
              future: principalOngAppController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Obx(
                    () => IndexedStack(
                      index: principalOngAppController.opcaoSelecionada.value,
                      children: <Widget>[
                  
                        InsertAnimalPage(),
                        SettingsPage(),
                      ],
                    ),
                );
                  } else {
                    return const Text('Nenhum pet dispongdfgfdgfdgfdgfdgfdgfível');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a listdfgfdgfdgfdgfdgfdga de pets: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 253, 72, 0),
                    ),
                  );
                }
              },
            ),
              
            );
          }),
    );
  }
}
