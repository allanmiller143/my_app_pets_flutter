// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class AnimalDetailPageController extends GetxController {

  late MeuControllerGlobal meuControllerGlobal;
  dynamic ongPetInfo = Get.arguments[0];
  dynamic usuarioInfo = Get.arguments[1];
  String localizacao = '${Get.arguments[0]['Estado']}, ${Get.arguments[0]['Cidade']}';
  String imagemFavorito = (Get.arguments[1]['Pets preferidos'].contains(Get.arguments[0]['Id'])) ? 'assets/ame.png': 'assets/ame2.png';  


  Future<String> func() async {
    meuControllerGlobal = Get.find();
    return 'allan';
  }

  getChatRoomByUserName(String a,String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
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
                    image: DecorationImage(
                      image: NetworkImage(animalDetailPageController.ongPetInfo['Imagem']),
                      fit: BoxFit.cover,
                    ), 
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
                                    animalDetailPageController.ongPetInfo['Nome animal'],
                                    style: TextStyle(fontFamily: 'AsapCondensed-Bold',fontSize: 28),
   
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.place_outlined,color: Color.fromARGB(255, 255, 94, 0),size: 15,),
                                    Text(animalDetailPageController.localizacao,
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
                              CustomCard(
                                  valor: animalDetailPageController.ongPetInfo['Sexo'],
                                  campo: 'Sexo',
                                  backgroundImage: 'assets/card1.png',
                                ),
                              
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['Idade'],
                                campo: 'Idade',
                                backgroundImage: 'assets/card2.png',
                              ),
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['Porte'],
                                campo: 'Porte',
                                backgroundImage: 'assets/card3.png',
                              ),
                              CustomCard(
                                valor: animalDetailPageController.ongPetInfo['Raça'],
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
                                                        Get.arguments[0]['Nome ong'],
                                                        style: TextStyle(fontFamily:'AsapCondensed-Bold',fontSize: 13)),      
                                                    Text(
                                                        Get.arguments[0]['E-mail'],
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
                                            onPressed: () async {
                                              var chatRoomId = animalDetailPageController.getChatRoomByUserName(animalDetailPageController.meuControllerGlobal.usuario['Id'], animalDetailPageController.ongPetInfo['Id']); // quem envia e quem recebe 
                                              Map<String, dynamic> chatRoomInfoMap = {
                                                'users' : [animalDetailPageController.meuControllerGlobal.usuario['Id'],animalDetailPageController.ongPetInfo['Id']],
                                              };

                                              await BancoDeDados.criaChatRoom(chatRoomId, chatRoomInfoMap);
                                              Get.toNamed('/chatConversa',arguments: [animalDetailPageController.ongPetInfo['Id'], animalDetailPageController.ongPetInfo['Nome']]);

                                            },
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
                                        maxLines: 2,
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
