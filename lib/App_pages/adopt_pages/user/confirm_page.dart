// ignore_for_file: must_be_immutable, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class AdoptConfirmPageController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  var ongPetInfo = Get.arguments[0];
  dynamic imagem = Get.arguments[0]['Imagem'];
  String nome = Get.arguments[0]['Nome animal'];

   func() async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
      return 'allan';
    }
    
    
  }
}

class AdoptConfirmPage extends StatelessWidget {
  AdoptConfirmPage({super.key});
  var adoptConfirmPageController = Get.put(AdoptConfirmPageController());

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: GetBuilder<AdoptConfirmPageController>(
        init: AdoptConfirmPageController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: adoptConfirmPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            color:const  Color.fromARGB(6, 236, 180, 12),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.47,
                            decoration: BoxDecoration(
                              image: DecorationImage(image:NetworkImage(adoptConfirmPageController.imagem), fit: BoxFit.cover),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(
                                        width: 35,
                                        height: 40,
                                        child: IconButton(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          icon:const  Icon(
                                            Icons.arrow_back_ios,
                                            size: 30,
                                            color: Color.fromARGB(255, 255, 255, 255),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.4,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.6,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 255, 255, 255),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(65),
                                topRight: Radius.circular(65),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                   Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Center(
                                              child: Text(
                                                'Você está adotando: ',
                                                style: TextStyle(fontFamily: 'AsapCondensed-Bold', fontSize: 28),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                            child: Text(
                                              adoptConfirmPageController.nome,
                                              style: const TextStyle(fontFamily: 'AsapCondensed-Medium', fontSize: 24),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                         const Padding(
                                            padding:  EdgeInsets.fromLTRB(5, 0, 0, 5),
                                            child: Text(
                                              "Importância da adoção",
                                              style: TextStyle(fontFamily: 'AsapCondensed-Bold', fontSize: 20),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                            child:  SizedBox(
                                              width: MediaQuery.of(context).size.width * 0.875,
                                              child:const  Text(
                                                'Adotar um pet é escolher amor e responsabilidade. Não só transforma a vida do animal, mas também contribui para reduzir animais em abrigos. Essa decisão enriquece nossas vidas, constrói uma comunidade consciente e dá a um pet a chance de um lar amoroso e alegre.',
                                                maxLines: 5,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(fontFamily: 'AsapCondensed-Medium', fontSize: 15),
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                            child: GestureDetector(
                                              onTap: () {
                                                print('veja mais');
                                              },
                                              child: const Text(
                                                'Para continuar a adoção clique no botão abaixo',
                                                style: TextStyle(
                                                  fontFamily: 'AsapCondensed-Bold',
                                                  fontSize: 16,
                                                  color: Color.fromARGB(255, 255, 81, 0),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  CustomIconButton(
                                    label: 'Continuar',
                                    onPressed: () {
                                      if(adoptConfirmPageController.meuControllerGlobal.usuario['Data'] == false){
                                        Get.toNamed('/insertUserDataPage',arguments: ['Insira seus dados','Para completar a adoção insira suas informações',adoptConfirmPageController.ongPetInfo]);
                                      }
                                      else{
                                        Get.toNamed('/userDataPage',arguments: [adoptConfirmPageController.ongPetInfo]);
 
                                      }

                                    },
                                    width: 250,
                                    alinhamento: MainAxisAlignment.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const SemInternetWidget();
                  }
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
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
