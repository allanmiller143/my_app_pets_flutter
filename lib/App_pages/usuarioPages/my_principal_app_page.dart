// ignore_for_file: must_be_immutabl
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/chat/chat.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/home_page.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/pets_page.dart';

class PrincipaAppController extends GetxController {
  RxInt opcaoSelecionada = 0.obs;
  Color corItemSelecionado = const Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = const  Color.fromARGB(255, 255, 255, 255);
  Future<String> func() async{
    return 'allan';
  }


  void mudaOpcaoSelecionada(int index) {
    opcaoSelecionada.value = index;
    update();
  }

}


class MyPrincipalAppPage extends StatelessWidget {
  const MyPrincipalAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    var principaAppController = PrincipaAppController();
    return MaterialApp(
      home: GetBuilder<PrincipaAppController>(
          init: PrincipaAppController(),
          builder: (_) {
            return Scaffold(
             
              bottomNavigationBar: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 0.1, color: Colors.black))),    
                  child: BottomNavigationBar(
                    elevation: 8,
                    onTap: (index) {
                      principaAppController.mudaOpcaoSelecionada(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    currentIndex: principaAppController.opcaoSelecionada.value,
                    backgroundColor:const Color.fromARGB(255, 255, 51, 0),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.pets_outlined),
                        label: 'Pets',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.chat),
                        label: 'chat',
                      ),
                   
                    ],
                    selectedItemColor: principaAppController.corItemSelecionado,
                    unselectedItemColor:principaAppController.corItemNaoSelecionado,
                  ),
                ),
              ),

              body: FutureBuilder(
              future: principaAppController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Obx(
                    () => IndexedStack(
                      index: principaAppController.opcaoSelecionada.value,
                      children: <Widget>[
                        HomePage(),
                        PetsPage(),
                        ChatPage(),
                      ],
                    ),
                );
                  } else {
                    return const Text('Nenhum pet');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a listd de pets: ${snapshot.error}');
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
