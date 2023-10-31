import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
//import 'package:mongo_dart/mongo_dart.dart';
import 'package:replica_google_classroom/App_pages/home_page.dart';
import 'package:replica_google_classroom/App_pages/profile_page.dart';
import 'package:replica_google_classroom/App_pages/search_page.dart';
import 'package:replica_google_classroom/App_pages/settings_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class PrincipaAppController extends GetxController {
  static PrincipaAppController get to => Get.find();

  final List<Map<String, dynamic>> pets;

  PrincipaAppController({required this.pets});
  var opcaoSelecionada = 2.obs;
  Color corItemSelecionado = Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = Color.fromARGB(255, 255, 255, 255);

  void mudaOpcaoSelecionada(int index) {
    opcaoSelecionada.value = index;
  }

  void reset() {}
}

class MyPrincipalAppPage extends StatelessWidget {
  final List<Map<String, dynamic>> pets;

  MyPrincipalAppPage({required this.pets, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final principaAppController = PrincipaAppController(pets: pets);
    return MaterialApp(
      home: GetBuilder<PrincipaAppController>(
          init: PrincipaAppController(pets: pets),
          builder: (_) {
            return Scaffold(
              drawer: Drawer(),
              appBar: AppBar(
                centerTitle: true,
                title: Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                  child: Container(
                    width: 250,
                    height: 450,
                    decoration: const BoxDecoration(
                        image:
                            DecorationImage(image: AssetImage('assets/5.png'))),
                  ),
                ),
                toolbarHeight: 70,
                backgroundColor: Color.fromARGB(255, 255, 51, 0),
                elevation: 1,
                leading: Builder(
                  builder: (context) {
                    return GestureDetector(
                      onTap: () {
                        Scaffold.of(context).openDrawer();
                        print(principaAppController.pets);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 17.5, 5, 17.5),
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/menu-lateral.png'))),
                        ),
                      ),
                    );
                  },
                ),
              ),
              bottomNavigationBar: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 0.1, color: Colors.black))),
                  child: BottomNavigationBar(
                    elevation: 8,
                    onTap: (index) {
                      principaAppController.mudaOpcaoSelecionada(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    currentIndex: principaAppController.opcaoSelecionada.value,
                    backgroundColor: Color.fromARGB(255, 255, 51, 0),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.search),
                        label: 'Search',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                    selectedItemColor: principaAppController.corItemSelecionado,
                    unselectedItemColor:
                        principaAppController.corItemNaoSelecionado,
                  ),
                ),
              ),
              body: Obx(
                () => IndexedStack(
                  index: principaAppController.opcaoSelecionada.value,
                  children: <Widget>[
                    HomePage(),
                    InsertAnimalPage(),
                    ProfilePage(),
                    SettingsPage(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
