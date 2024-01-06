import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/animal_detail_page.dart';

class XController extends GetxController {
  dynamic ongPetInfo = Get.arguments[0];
  dynamic usuarioInfo = Get.arguments[1];
  String imagemFavorito = (Get.arguments[1]['preferedPetsList'].contains(Get.arguments[0]['id'])) ? 'assets/ame.png': 'assets/ame2.png';  
  dynamic imagem = Get.arguments[0]['imagem'];
  String imagemPadrao = Get.arguments[0]['tipo']  == '1' ? 'assets/exemplo1.png':'assets/exemplo2.png';
  String tipo = Get.arguments[1]['Tipo']; 
  dynamic imageProvider;


  Future<String> func() async {
    return 'allan';
  }

 
}

// ignore: must_be_immutable
class XPage extends StatelessWidget {
  XPage({super.key});
  var xController = Get.put(XController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<XController>(
        init: XController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: xController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                   children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 200,
                      color: Colors.amber,
                    ),
                     Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed('/insertUserDataPage');
                                    },
                                    child: CustomCard(
                                      valor: xController.ongPetInfo['sexo'],
                                      campo: 'Sexo',
                                      backgroundImage: 'assets/card1.png',
                                    ),
                                  ),
                                  CustomCard(
                                    valor: xController.ongPetInfo['idade'],
                                    campo: 'valor',
                                    backgroundImage: 'assets/card2.png',
                                  ),
                                  CustomCard(
                                    valor: xController.ongPetInfo['porte'],
                                    campo: 'Porte',
                                    backgroundImage: 'assets/card3.png',
                                  ),
                                  CustomCard(
                                    valor: xController.ongPetInfo['raca'],
                                    campo: 'Raça',
                                    backgroundImage: 'assets/card4.png',
                                  ),
                                ],
                              ),
                            ),
                   ],
                 );
                  } else {
                    return const Text('Nenhum pet disponível');
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
