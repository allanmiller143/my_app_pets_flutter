// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_print
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import '../app_widgets/my_animal_card.dart';
import '../ongPages/componentesOngPerfil/my_pick_pet_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PetsController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  RxString selectedType = '5'.obs;
  Map<String,dynamic>? usuario;
  List<dynamic> favoritPetIds = [];  
  List<Map<String, dynamic>> pets = [];
  List<Map<String, dynamic>> petsInfo = [];
  List<Map<String, dynamic>> petsInfo2 = [];

  alteraLista(tipo)async {
    meuControllerGlobal = Get.find();
    usuario = meuControllerGlobal.usuario;
    if(meuControllerGlobal.internet.value){
      favoritPetIds = usuario!['Pets preferidos'];
      meuControllerGlobal.petsSistema = await BancoDeDados.obterPets();
      pets = meuControllerGlobal.petsSistema;
      return 'allan';
    }
  }
  
  void retornaLista(String filtro, int init) {
    petsInfo = [];
    petsInfo2 = [];

    int tamanhoLista = pets.length;
    print(tamanhoLista);
    print(pets);

    if (tamanhoLista % 2 != 0) {
      tamanhoLista = tamanhoLista - 1;
    }
    int cont = 1;
    if (tamanhoLista != 0) {
      for (int i = 0; i < tamanhoLista; i++) {
        pets[i]['posicao'] = i;
        if (filtro != '5') {
          if (pets[i]['Tipo animal'] == filtro) {
            if (cont % 2 != 0) {
              petsInfo.add(pets[i]);
            } else {
              petsInfo2.add(pets[i]);
            }
            cont++;
          }
        } else {
          if (i % 2 != 0) {
            petsInfo.add(pets[i]);
          } else {
            petsInfo2.add(pets[i]);
          }
        }
      }
    }
    if (init != 1) {
      update();
    }
  } 
  List<Widget> generateAnimalCards(petsInfo) {
    List<Widget> cards = [];
    for (var petInfo in petsInfo) {
      cards.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: AnimalCard(
            pet: petInfo,
            onPressed: () {
              int p = petInfo['posicao'];
                Get.toNamed('/animalDetail', arguments: [pets[p],usuario]);    
            },
            meuControllerGlobal: meuControllerGlobal,
          ),
        ),
      );
    }
    return cards;
  }
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 200,
          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Inserir uma foto',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title: Text(
                  'Galeria',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
              
                },
              ),
              ListTile(
                title: Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class PetsPage extends StatelessWidget {
  PetsPage({super.key});
  var petsController = Get.put(PetsController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<PetsController>(
        init: PetsController(),
        builder: (_) {
          return Scaffold(
            body:FutureBuilder( // usa-se futureBuilder, pq preciso carregar a lista de pets antes de criar a tela.
            future:  petsController.alteraLista('-1'), 
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  petsController.retornaLista(petsController.selectedType.value, 1);
                  return SingleChildScrollView(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.21,
                        color: Color.fromARGB(255, 255, 255, 255),
                        child: Stack(
                          children: [
                            Container(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.166,
                              decoration: BoxDecoration(
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
                                    height: MediaQuery.of(context).size.height * 0.319,
                                    decoration: BoxDecoration(
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
                                shape: RoundedRectangleBorder(
                                  borderRadius:BorderRadius.all(Radius.circular(30))  
                                ),
                                child: Container(
                                  width: 360,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    color: Color.fromARGB(255, 255, 255, 255),
                                    borderRadius: BorderRadius.all(Radius.circular(30))     
                                  ),
                                  child: Row(
                                    mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                        child: Text(
                                          'Filtrar',
                                          style: TextStyle(fontSize: 20,fontFamily:'AsapCondensed-Light'),         
                                        ),
                                      ),
                                      Container(
                                        width: 55,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color:Color.fromARGB(255, 17, 61, 94),
                                          borderRadius:BorderRadius.circular(40)
                                        ),     
                                        child: IconButton(
                                          onPressed: (){
                                            petsController.showBottomSheet(context);
                                            
                                          },
                                          icon: Icon(Icons.filter_alt_outlined),
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(22, 0, 22, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:const EdgeInsets.fromLTRB(2, 0, 0, 10),
                                  child: Text(
                                    'Categorias',
                                    style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Bold'),     
                                  ),
                                ),
                              ],
                            ),
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                mainAxisAlignment:MainAxisAlignment.spaceEvenly, 
                                children: [
                                  CustomPickPet(
                                    onPressed: () {
                                      petsController.selectedType.value ='5';
                                      petsController.retornaLista('5',2);  
                                    },
                                    imagePath: 'assets/outros.png',
                                    tipo: "5",
                                    controller:petsController.selectedType,
                                    text: 'Todos'),
                                  CustomPickPet(
                                    onPressed: () {
                                      petsController.selectedType.value = '1';
                                      petsController.retornaLista('1',2);
                                    },
                                    imagePath: 'assets/doguinho.png',
                                    tipo: "1",
                                    controller:petsController.selectedType,
                                    text: 'Cachorros'
                                  ),
                                  CustomPickPet(
                                    onPressed: () {
                                      petsController.selectedType.value ='2';
                                      petsController.retornaLista('2',2);
                                    },
                                    imagePath: 'assets/gatinho.png',
                                    tipo: "2",
                                    controller:petsController.selectedType,
                                    text: 'Gatos'
                                  ),
                                  CustomPickPet(
                                    onPressed: () {
                                      petsController.selectedType.value ='3';
                                      petsController.retornaLista('3',2);    
                                    },
                                    imagePath: 'assets/passarinho.png',
                                    tipo: "3",
                                    controller:petsController.selectedType, 
                                    text: 'Pássaros'),
                                    CustomPickPet(
                                    onPressed: () {
                                      petsController.selectedType.value ='4';
                                      petsController.retornaLista('4',2);    
                                    },
                                    imagePath: 'assets/passarinho.png',
                                    tipo: "4",
                                    controller:petsController.selectedType, 
                                    text: 'Outros'),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(2, 0, 0, 10), 
                                        child: Text(
                                          'Esperando por você',
                                          style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Bold'),   
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width:MediaQuery.of(context).size.width - 40,
                                    height: MediaQuery.of(context).size.height * 0.53,
                                    child: SingleChildScrollView(
                                      child: Column(
                                        mainAxisAlignment:MainAxisAlignment.spaceBetween,   
                                        children: [
                                          Row(
                                            mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children:[
                                              Column(
                                                children: petsController.generateAnimalCards(petsController.petsInfo), // Use a função para gerar os cards             
                                              ),
                                              Column(
                                                children: petsController.generateAnimalCards(petsController.petsInfo2) // Gere mais cards conforme necessário               
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ], 
                                    ),
                  );
                } 
                else {
                  return  SemInternetWidget();
                }
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0),));
              }
            },
          ), 

          );
        }   
      ),
    );
  }
}