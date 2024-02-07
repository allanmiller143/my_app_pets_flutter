// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import '../app_widgets/my_animal_card.dart';

class FavoritsController extends GetxController {
  List<Map<String, dynamic>> pets = [];
  List<dynamic> favoritPetIds = [];
  late MeuControllerGlobal meuControllerGlobal;

   alteraLista() async {
    meuControllerGlobal = Get.find();
    if(meuControllerGlobal.internet.value){
        pets = meuControllerGlobal.petsSistema;
        favoritPetIds = meuControllerGlobal.usuario['Pets preferidos'];
        return pets;
    }
    
  }

  List<Widget> mostraFeed() {
    List<Widget> rows = [];
    if (pets.isEmpty) {
      rows.add(
        const Padding(
          padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
          child: Center(
            child: Text(
              "Você não possui Pets\nfavoritados",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      );
      return rows;
    }
    int contador = 0;

    for (int i = 0; i < pets.length; i += 2) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 2 && j < pets.length; j++) {
        if (favoritPetIds.contains(pets[j]['Id animal'])) {
          contador++;
          rowChildren.add(
            Padding(
              padding: const EdgeInsets.fromLTRB(5, 0, 5, 15),
              child: AnimalCard(
                pet: pets[j],
                onPressed: () {
                  Get.toNamed('/animalDetail', arguments: [pets[j], meuControllerGlobal.usuario]);
                },
                meuControllerGlobal: meuControllerGlobal,
              ),
            ),
          );
        }
      }
      if (contador == 2 || i + 2 >= pets.length) {
        contador = 0;
        rows.add(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: rowChildren,
          ),
        );
      }
    }

    return rows;
  }
}

class FavoritsPage extends StatelessWidget {
  FavoritsPage({super.key});
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
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              leading: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(Icons.arrow_back_ios, color: const Color.fromARGB(255, 255, 255, 255)),
              ),
            ),

            body: FutureBuilder(
              future: favoritsController.alteraLista(),
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
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 250,
                                      height: 50,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(image: AssetImage('assets/5.png'), fit: BoxFit.cover)),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 95,
                                left: 15,
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(30)),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *0.9,
                                    height: 55,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 255, 255),
                                        borderRadius: BorderRadius.all(Radius.circular(30))),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: SizedBox(
                 
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 0),
                                        child: Text(
                                          'Seus favoritos',
                                          style: TextStyle(fontSize: 25, fontFamily: 'AsapCondensed-Bold'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Expanded(
                                    child: Container(
                            
                                      width: MediaQuery.of(context).size.width,
                                      child: SingleChildScrollView(
                                        child: Column(
                                      
                                          children: favoritsController.mostraFeed(),
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
                  } else {
                    return SemInternetWidget();
                  }
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
                } else {
                  return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0)));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
