
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/ong/todasAdocoes.dart';
import 'package:replica_google_classroom/App_pages/chat/chat.dart';
import 'package:replica_google_classroom/App_pages/ongPages/insert_animal_page.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';


class PrincipalOngAppController extends GetxController {
  var opcaoSelecionada = 0.obs;
  Color corItemSelecionado = const Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = const  Color.fromARGB(255, 255, 255, 255);



  Future<String> func() async{
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
                        label: 'Conversas',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Adoções',
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
                        SettingsPage(),
                        InsertAnimalPage(),
                        ChatPage(),
                        TodasAdocoesPage(),
                       
                        
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
