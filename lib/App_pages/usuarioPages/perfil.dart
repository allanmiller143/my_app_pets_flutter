// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';


class PerfilUsuarioController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;

  func() async {
    meuControllerGlobal = Get.find();

    if(meuControllerGlobal.internet.value){
      return 'allan';
    }

  }

 
}

// ignore: must_be_immutable
class PerfilUsuarioPage extends StatelessWidget {
  PerfilUsuarioPage({super.key});
  var perfilUsuarioController = Get.put(PerfilUsuarioController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<PerfilUsuarioController>(
        init: PerfilUsuarioController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: perfilUsuarioController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                      width: double.infinity,
                      height: 165,
                      color:const  Color.fromARGB(255, 255, 255, 255),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 130,
                            decoration:const  BoxDecoration(
                              color: Color.fromARGB(255, 255, 51, 0),
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20)
                              )
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 250,
                                  height: 50,
                                  decoration:const  BoxDecoration(
                                      image: DecorationImage(
                                        image: AssetImage('assets/5.png'),
                                        fit: BoxFit.cover)
                                  ),
                                ),
                              ],
                            )
                          ),
                          Positioned(
                            top: 95,
                            left: 15,
                            child: Card(
                              elevation: 8,
                              shape:const  RoundedRectangleBorder(
                                borderRadius:BorderRadius.all(Radius.circular(30))  
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                height: 55,
                                decoration:const  BoxDecoration(
                                  color: Color.fromARGB(255, 255, 255, 255),
                                  borderRadius: BorderRadius.all(Radius.circular(30))     
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(20,0,20,0),
                          child: 
                            SingleChildScrollView(
                              scrollDirection: Axis.vertical,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      print('Abrir tela de edição de dados');
                                      Get.toNamed("/exluirAlterarPage");
                                    },
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        padding:const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: ListTile(
                                          title: Text('Suas informações'),
                                          subtitle: Text('Editar/excluir'),
                                          leading: Icon(Icons.person),
                                          trailing: Icon(Icons.arrow_drop_down_sharp,size: 25,),
                                                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  GestureDetector(
                                    onTap: (){
                                      print('Pets favoritados');
                                      Get.toNamed('/favorits');
                                    },
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        padding:const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: ListTile(
                                          title: Text('Pets favoritos'),
                                          subtitle: Text('Veja seus pets favoritos'),
                                          leading: Icon(Icons.pets),
                                          trailing: Icon(Icons.arrow_drop_down_sharp,size: 25,),
                                                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 20,),
                                  GestureDetector(
                                    onTap: (){
                                      Get.toNamed('/adocoesUsuario');
                                    },
                                    child: Material(
                                      elevation: 5,
                                      borderRadius: BorderRadius.circular(10),
                                      child: Container(
                                        width: double.infinity,
                                        padding:const EdgeInsets.fromLTRB(0, 10, 0, 10),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: const Center(
                                          child: ListTile(
                                            title: Text('Suas adoções'),
                                            subtitle: Text('Suas adoções em andamento/finalizadas'),
                                            leading: Icon(Icons.art_track),
                                            trailing: Icon(Icons.arrow_drop_down_sharp,size: 25,),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ), 
                        ),
                      ) 
                    ],
                  );
                  } 
                  else {
                    return const SemInternetWidget();
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a lista de pets: ${snapshot.error}');
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
        },
      ),
    );
  }
}
