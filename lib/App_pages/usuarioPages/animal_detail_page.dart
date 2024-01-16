// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class AnimalDetailPageController extends GetxController {
  late SenhaController senhaController;
  dynamic ongPetInfo = Get.arguments[0];
  dynamic usuarioInfo = Get.arguments[1];
  String imagemFavorito = (Get.arguments[1]['preferedPetsList'].contains(Get.arguments[0]['id'])) ? 'assets/ame.png': 'assets/ame2.png';  
  dynamic imagem = Get.arguments[0]['imagem'];
  String imagemPadrao = Get.arguments[0]['tipo']  == '1' ? 'assets/exemplo1.png':'assets/exemplo2.png';
  String tipo = Get.arguments[1]['Tipo']; 
  dynamic imageProvider;
  
  void atualiza(){
    update();
  }


  ImageProvider<Object> convertBase64ToImageProvider(dynamic base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }

  

  Future<String> func() async {
    senhaController = Get.find();
    imageProvider = imagem != null? convertBase64ToImageProvider(imagem): AssetImage(imagemPadrao);
    return 'allan';
  }

 
}

// ignore: must_be_immutable
class AnimalInsertPage extends StatelessWidget {
  AnimalInsertPage({super.key});
  var animalDetailPageController = Get.put(AnimalDetailPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<AnimalDetailPageController>(
        init: AnimalDetailPageController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: animalDetailPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Scaffold(
            body: Stack(
            children: [
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: Color.fromARGB(6, 236, 180, 12),
                ),
              ),
              Positioned(
                top: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.47,
                  decoration: BoxDecoration(
                    image: DecorationImage(image: animalDetailPageController.imageProvider,fit: BoxFit.cover,), 
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(25, 30, 25, 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 35,
                              height: 40,
                              child: IconButton(
                                padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                onPressed: () {Get.back();},
                                icon: Icon( size: 30,color:const Color.fromARGB(255, 255, 255, 255),Icons.arrow_back_ios,), 
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
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 255, 255),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(65),
                        topRight: Radius.circular(65),
                      )),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 25, 20, 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:const EdgeInsets.fromLTRB(5, 0, 5, 0),    
                                  child: Text(
                                    animalDetailPageController.ongPetInfo['nome'],
                                    style: TextStyle(fontFamily: 'AsapCondensed-Bold',fontSize: 28),
   
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.place_outlined,color: Color.fromARGB(255, 255, 94, 0),size: 15,),
                                    Text(animalDetailPageController.ongPetInfo['localizacao'],
                                    style: TextStyle(fontFamily: 'AsapCondensed-Medium',fontSize: 15))      
                                  ],
                                )
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 30, 0),
                              child: Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(animalDetailPageController.imagemFavorito),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () async{
                                  await animalDetailPageController.senhaController.recarregarInfo();
                                  print(animalDetailPageController.senhaController.pets[0]['nomeOng']);
                                  print(animalDetailPageController.ongPetInfo[0]['nomeOng']);
                                },
                                child: CustomCard(
                                  valor: animalDetailPageController.ongPetInfo['sexo'],
                                  campo: 'Sexo',
                                  backgroundImage: 'assets/card1.png',
                                ),
                              ),
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['idade'],
                                campo: 'valor',
                                backgroundImage: 'assets/card2.png',
                              ),
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['porte'],
                                campo: 'Porte',
                                backgroundImage: 'assets/card3.png',
                              ),
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['raca'],
                                campo: 'Raça',
                                backgroundImage: 'assets/card4.png',
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/ongProfilePage',arguments: [animalDetailPageController.ongPetInfo]);
                                },
                                child: Card(
                                  elevation: 8,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.875,
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius:BorderRadius.all(Radius.circular(15)),   
                                    ),
                                    child: Row(
                                      mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Container(
                                                width: 60,
                                                height: 60,
                                                decoration: BoxDecoration(
                                                  color: Color.fromARGB(255, 211, 248, 247),   
                                                  borderRadius: BorderRadius.all(Radius.circular(50),),
                                                  image: DecorationImage(
                                                    image: AssetImage('assets/menu-lateral.png'),fit: BoxFit.cover,),
                                                ),
                                              ),
                                              Padding(
                                                padding:const EdgeInsets.fromLTRB(10, 0, 0, 0),    
                                                child: Column(
                                                  crossAxisAlignment:CrossAxisAlignment.start,
                                                  mainAxisAlignment:MainAxisAlignment.spaceEvenly,        
                                                  children: [
                                                    Text(
                                                        Get.arguments[0]['nomeOng'],
                                                        style: TextStyle(fontFamily:'AsapCondensed-Bold',fontSize: 13)),      
                                                    Text(
                                                        Get.arguments[0]['email'],
                                                        style: TextStyle(fontFamily:'AsapCondensed-Medium',fontSize: 13)),    
                                                    Row(
                                                      children: [
                                                        Icon(Icons.verified,size: 15,),
                                                        Text('verificado',style: TextStyle( fontFamily:'AsapCondensed-Medium',fontSize: 13))       
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        IconButton(
                                            onPressed: () {},
                                            icon: Icon(
                                              Icons.message,
                                              color: Color.fromARGB(
                                                  255, 252, 116, 5),
                                            ))
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Text("Detalhes da Raça",
                                      style: TextStyle(
                                          fontFamily: 'AsapCondensed-Bold',
                                          fontSize: 16)),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.875,
                                    child: Text(
                                        'Os vira-latas são cães sem raça definida, conhecidos por sua inteligência, lealdade e capacvalor de adaptação. São frequentemente encontrados em situações de resgate e fazem companheiros amorosos. Adotar um vira-lata é uma oportunvalor de dar um lar a um cão necessitado e fazer a diferença no mundo dos animais.',
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontFamily: 'AsapCondensed-Medium',
                                            fontSize: 12)),
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(5, 0, 0, 5),
                                  child: GestureDetector(
                                    onTap: () {
                                      
                                      print('veja mais');
                                    },
                                    child: Text('Veja Mais',
                                        style: TextStyle(
                                            fontFamily: 'AsapCondensed-Bold',
                                            fontSize: 14,
                                            color: Color.fromARGB(
                                                255, 255, 81, 0))),
                                  ),
                                )
                                //richText
                              ],
                            )
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CustomIconButton(
                              label: 'Adote agora',
                              onPressed: () {
                                Get.toNamed('/adoptConfirmPage',arguments: [animalDetailPageController.ongPetInfo]);
                              },
                              width: 250,
                              alinhamento: MainAxisAlignment.center,
                              raio: 15,
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ));
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


class CustomCard extends StatelessWidget {
  final String valor;
  final String campo;
  final String backgroundImage;

  CustomCard({
    required this.valor,
    required this.campo,
    required this.backgroundImage,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 20,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(
            image: AssetImage(backgroundImage),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(valor, style: TextStyle(fontFamily: 'AsapCondensed-Bold')),
            Text(campo,
                style: TextStyle(
                    fontFamily: 'AsapCondensed-ExtraLight', fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
