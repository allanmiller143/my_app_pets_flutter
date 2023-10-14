import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/home_page.dart';
import 'package:replica_google_classroom/App_pages/profile_page.dart';
import 'package:replica_google_classroom/App_pages/search_page.dart';
import 'package:replica_google_classroom/App_pages/settings_page.dart';

class PrincipaAppController extends GetxController {
  static PrincipaAppController get to => Get.find();
  var opcaoSelecionada = 0.obs;
  Color corItemSelecionado = const Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = const Color.fromARGB(255, 255, 255, 255);

  void mudaOpcaoSelecionada(int index) {
    opcaoSelecionada.value = index;
  }

  void reset() {}
}

class MyPrincipalAppPage extends StatelessWidget {
  MyPrincipalAppPage({Key? key}) : super(key: key);

  final principaAppController = Get.put(PrincipaAppController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<PrincipaAppController>(
          init: PrincipaAppController(),
          builder: (_) {
            return Scaffold(
                appBar: AppBar(
                  title: const Text("Meu App"),
                ),
                drawer: const Drawer(),
                bottomNavigationBar: Obx(
                  () => BottomNavigationBar(
                    onTap: (index) {
                      principaAppController.mudaOpcaoSelecionada(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    currentIndex: principaAppController.opcaoSelecionada.value,
                    backgroundColor: Color.fromARGB(255, 255, 103, 2),
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
                body: Obx(
                  () => IndexedStack(
                    index: principaAppController.opcaoSelecionada.value,
                    children: <Widget>[
                      HomePage(),
                      ProfilePage(),
                      SettingsPage(),
                      SearchPage(),
                    ],
                  ),
                ));
          }),
    );
  }
}
