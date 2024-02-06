// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import '../app_widgets/my_custom_card_home_page.dart';
import '../app_widgets/my_animal_card.dart';

class HomePageController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;

  List<Map<String, dynamic>> pets = [];
  dynamic usuario;


  alteraLista() async {
    meuControllerGlobal = Get.find();
    usuario = meuControllerGlobal.usuario;
    if(meuControllerGlobal.internet.value == true){
      print('entrei aqui hihi');
      meuControllerGlobal.petsSistema = await BancoDeDados.obterPets();
      pets = meuControllerGlobal.petsSistema;
      return pets;
    }
  }
}

class HomePage extends StatelessWidget {
  HomePage({super.key});
  var homePageController = Get.put(HomePageController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<HomePageController>(
        init: HomePageController(),
        builder: (_) {
          return Scaffold(
            body:FutureBuilder(
            future: homePageController.alteraLista(),
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
                      color: Color.fromARGB(255, 255, 255, 255),
                      child: Stack(
                        children: [
                          Container(
                            width: double.infinity,
                            height: 130,
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
                                  height: 50,
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
                                width: MediaQuery.of(context).size.width *0.9,
                                height: 55,
                                decoration: BoxDecoration(
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
                                    Container(
                                      width: double.infinity,
                                      height: MediaQuery.of(context).size.width *0.4,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: AssetImage('assets/banner2.png'),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 5, 0, 5),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Categorias',
                                                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Bold'),   
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              CustomCardHomePage(
                                                onPressed: () async {
                                                  Get.toNamed('/profilePage',arguments: ['1']);
                                                  },
                                                imagePath: 'assets/doguinho.png',
                                                text: 'Cachorros',
                                                backgroundImageColor:const Color.fromARGB(255, 255, 255, 255),  
                                                containerColor:const Color.fromARGB(255, 255, 81, 0),    
                                                textColor:const Color.fromARGB(255, 255, 255, 255),  
                                              ),
                                              CustomCardHomePage(
                                                onPressed: () {Get.toNamed('/profilePage',arguments: ['2']);},
                                                imagePath: 'assets/gatinho.png',
                                                text: 'Gatos',
                                              ),
                                              CustomCardHomePage(
                                                onPressed: () {Get.toNamed('/profilePage',arguments: ['3']);},
                                                imagePath: 'assets/passarinho.png',
                                                text: 'Pássaros',
                                              ),
                                              CustomCardHomePage(
                                                onPressed: () {Get.toNamed('/profilePage',arguments: ["4"]);},
                                                imagePath: 'assets/outros.png',
                                                text: 'Outros',
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                         Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed('/profilePage',arguments: ['5']);
                                                },
                                                child: Text(
                                                  'Veja todos',
                                                  style: TextStyle(fontSize: 15,fontFamily: 'AsapCondensed-Light'),     
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          width: double.infinity,
                          
                                          child: SingleChildScrollView(
                                            scrollDirection: Axis.horizontal,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                homePageController.pets.isNotEmpty ?
                                                AnimalCard(
                                                pet: homePageController.pets[0],
                                                onPressed: () {
                                                  Get.toNamed('/animalDetail', arguments: [homePageController.pets[0],homePageController.usuario]);       
                                                        
                                                  //Get.toNamed('/animalDetail', arguments: [homePageController.pets[0],homePageController.usuario]);       
                                                },
                                                meuControllerGlobal: homePageController.meuControllerGlobal,
                                                        
                                              ): Text('Estamos sem nenhum pet no sistema'),
                                              homePageController.pets.length > 1 ?
                                              AnimalCard(
                                                pet: homePageController.pets[1],
                                                onPressed: () {
                                                  Get.toNamed('/animalDetail', arguments: [homePageController.pets[1],homePageController.usuario]);
                                                },     
                                                meuControllerGlobal: homePageController.meuControllerGlobal,
                                                        
                                              ):SizedBox(),
                                              homePageController.pets.length > 2 ?
                                              AnimalCard(
                                                pet: homePageController.pets[2],
                                                onPressed: () {
                                                  Get.toNamed('/animalDetail', arguments: [homePageController.pets[2],homePageController.usuario]);    
                                                },
                                                meuControllerGlobal: homePageController.meuControllerGlobal,
                                              ):SizedBox()
                                              ],
                                            ),
                                            
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            
                          
                        ),
                      ) 
                    ],
                  );
                } else {
                  return SemInternetWidget();
                }
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
              } else {
                return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0),));
              }
            },
          ),

          );
        },
      ),
    );
  }
}
