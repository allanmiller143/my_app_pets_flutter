// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import '../app_widgets/my_animal_card.dart';

class FavoritsController extends GetxController {
  static FavoritsController get to => Get.find(); 
  List<Map<String, dynamic>> pets = [];
  List<dynamic> favoritPetIds = [];
  List<Map<String, dynamic>> petsInfo = [];
  List<Map<String, dynamic>> petsInfo2 = [];
  Map<String,dynamic>? usuario;
  late SenhaController senhaController;

  Future<List<Map<String,dynamic>>> alteraLista() async {
    senhaController = Get.find();
    pets = await MongoDataBase.retornaListaPets();
    usuario = await MongoDataBase.retornaUsuarioCompleto(Get.arguments[1]);
    favoritPetIds = [];
    favoritPetIds = await MongoDataBase.retornaPetIds(Get.arguments[0]);
    return pets;
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
            petIds: favoritPetIds,
            cpf: '',
            senhaController: senhaController,
          ),
        ),
      );
    }
    return cards;
  }

  void retornaLista() {
    petsInfo = [];
    petsInfo2 = [];

    int tamanhoLista = pets.length;

    int cont = 1;
    if (tamanhoLista != 0) {
      for (int i = 0; i < tamanhoLista; i++) {
        pets[i]['posicao'] = i; // adiciona a posicao para poder poder controlar as informcaoes quando chamar a tela de detalhes 
        if(favoritPetIds.contains(pets[i]['id'])){
          if(cont%2 != 0){
            petsInfo.add(pets[i]);
          }
          else{
            petsInfo2.add(pets[i]);
          }
          cont++;
        }
      }
    }
  }
}

class FavoritsPage extends StatelessWidget {
  FavoritsPage({Key? key}) : super(key: key);
  var favoritsController = Get.put(FavoritsController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<FavoritsController>(
        init: FavoritsController(),
        builder: (_) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              forceMaterialTransparency: true,
              toolbarHeight: 85,
              leading: GestureDetector( onTap: () {  Get.back();}, child: Icon(Icons.arrow_back_ios,color: const Color.fromARGB(255, 255, 255, 255),)),
            ),
            body:FutureBuilder(
            future: favoritsController.alteraLista(), // Remova os parênteses para não executar a função aqui
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  favoritsController.retornaLista();
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
                                width: 360,
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
                
                    Container(
                      width: double.infinity,
                      height: 610,
                        child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(15,0,10,0),
                                      child: Text('Seus favoritos',style: TextStyle(fontSize: 25,fontFamily:'AsapCondensed-Bold'),),
                                    ),
                                  ],
                                ),
                             Container(
                                  width:MediaQuery.of(context).size.width - 40,
                                  height: 550,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,   
                                      children: [
                                        Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children:[
                                            Column(
                                              children: favoritsController.generateAnimalCards(favoritsController.petsInfo), // Use a função para gerar os cards             
                                            ),
                                            Column(
                                              children: favoritsController.generateAnimalCards(favoritsController.petsInfo2) // Gere mais cards conforme necessário               
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
                    )  
                    ],
                  );
                } else {
                  return Text('Nenhum pet disponível');
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
