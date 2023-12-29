// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/my_animal_card.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import '../app_widgets/pet_register_widgets/photo_container.dart';
import '../app_widgets/my_custom_card_home_page.dart';


class OngProfileController extends GetxController {
  dynamic ongPetInfo = Get.arguments[0];
  dynamic usuarioInfo = Get.arguments[1];
  late SenhaController senhaController;

  Map<String,dynamic>? ongInfo;
  List<dynamic> ongPets = [];
  List<dynamic> favoritPetIds = [];
  List<Map<String, dynamic>> petsInfo = [];
  List<Map<String, dynamic>> petsInfo2 = [];
  File? imageFile;

  String tipo = Get.arguments[1]['Tipo'];

  Future<dynamic> alteraLista() async {
    final stopwatch = Stopwatch()..start();
    if(tipo == '2'){
      print('entrei');
      favoritPetIds = [];
      favoritPetIds = Get.arguments[1]['preferedPetsList'];
      ongPets = await MongoDataBase.retornaListaPetsOng(Get.arguments[0]['cnpj']);
      ongInfo = await MongoDataBase.retornaOngCompleta(Get.arguments[0]['email']);
    }else{
      print('entrei na segunda');
      favoritPetIds = [];
      favoritPetIds = Get.arguments[1]['preferedPetsList'];
      ongPets = ongPets = await MongoDataBase.retornaListaPetsOng(Get.arguments[0]['cnpj']);
      ongInfo = Get.arguments[0];  
    }
    stopwatch.stop();

    // Tempo total de execução em milissegundos
    final int executionTime = stopwatch.elapsedMilliseconds;
    print("O tempo de execução foi de $executionTime milissegundos.");

    return ongPets;
  }
  List<Widget> geraAnimalCardsUser(petsInfo,n){
    List<Widget> cards = [];
    for(var pet in petsInfo){
      print(pet);
      cards.add(
        AnimalCard(onPressed: (){
          Get.toNamed('/animalDetail', arguments: [pet,usuarioInfo]);
        },
        pet: pet,
        senhaController: senhaController,
        )
      );
    }
    return cards;

  }

  List<Widget> generateAnimalCards(petsInfo,n) {
    List<Widget> cards = [];
    for (var petInfo in petsInfo) {
      cards.add(
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
          child: AnimalCard2(
            pet: petInfo,
            height: n%2 == 0 ? 200 : 170,
            onPressed: () {
               int p = petInfo['posicao']; 
               Get.toNamed('/animalDetail', arguments: [ongPets[p],usuarioInfo]); 
            },
          ),
        ),
      ); 
      n++;
    }
    return cards;
  }

  void retornaLista() {
    petsInfo = [];
    petsInfo2 = [];

    int tamanhoLista = ongPets.length;

    int cont = 1;
    if (tamanhoLista != 0) {
      for (int i = 0; i < tamanhoLista; i++) {
        ongPets[i]['posicao'] = i; // adiciona a posicao para poder poder controlar as informcaoes quando chamar a tela de detalhes 

          if(cont%2 != 0){
            petsInfo.add(ongPets[i]);
          }
          else{
            petsInfo2.add(ongPets[i]);
          }
          cont++;
        }
      }
  }
  void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile!.readAsBytes(); // Converta a imagem em um array de bytes  
      String base64Image = base64Encode(imageBytes); // Codifique os bytes em formato base64 (opcional)
      await MongoDataBase.insereImagemPerfil(Get.arguments[0],base64Image);
      update();
    }
  }
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // Conteúdo do BottomSheet
          height: 200,

          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Inserir uma foto',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title:const  Text(
                  'Galeria',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                title: const Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading:const  Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void showBottomSheetEdit(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // Conteúdo do BottomSheet
          height: 200,
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Editar Perfil',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title:const  Text(
                  'Informações de Perfil',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  Get.toNamed('/ongEditBioProfilePage');
                },
              ),
              ListTile(
                title: const Text(
                  'Bio',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading:const  Icon(
                  Icons.text_snippet_rounded,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  Get.toNamed('/ongEditBioProfilePage',arguments: [ongInfo!['bio']]);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}



// ignore: must_be_immutable
class OngProfilePage extends StatelessWidget {
  OngProfilePage({super.key});
  var ongProfileController = Get.put(OngProfileController());  
  @override
  
  Widget build(BuildContext context) {
    return MaterialApp(
    home: GetBuilder<OngProfileController>(
    init: OngProfileController(),
    builder: (_) {
      return  Scaffold(
        body:FutureBuilder(
            future: ongProfileController.alteraLista(), // Remova os parênteses para não executar a função aqui
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  ongProfileController.retornaLista();
                  return Column(
          children: [
            Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: const BoxDecoration(image: DecorationImage(image: AssetImage('assets/fundoOng.png'),fit: BoxFit.cover)),   
                  ),  
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left:  MediaQuery.of(context).size.width * 0.05,
                    child: IconButton( onPressed: (){Get.back();}, icon: const Icon(Icons.arrow_back_ios_new,color:  Color.fromARGB(255, 255, 255, 255)),)
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left:  MediaQuery.of(context).size.width * 0.05,
                    child: PhotoContainer(onPressed: (){ ongProfileController.showBottomSheet(context);}, image: ongProfileController.imageFile,imagembd: ongProfileController.ongInfo!['imagemPerfil'],),
                  ),
                  ongProfileController.tipo == 2 ? 
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.23,
                    left:  MediaQuery.of(context).size.width * 0.5,
                    child: GestureDetector(
                      onTap: (){
                        ongProfileController.showBottomSheetEdit(context);},
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: MediaQuery.of(context).size.height * 0.04,
                          decoration: BoxDecoration(
                            color:const  Color.fromARGB(255, 107, 106, 104),
                            borderRadius: BorderRadius.circular(5) 
                          ),
                          child: const Center(child: Text('Editar Perfil',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),)),
                        ),
                    ),
                  ):const SizedBox(),
                ]   
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(25,10,25,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(ongProfileController.ongInfo!['nomeOng'],style:const  TextStyle(fontSize: 22,fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Text(ongProfileController.ongInfo!['localizacao'],style: const TextStyle(fontWeight: FontWeight.w200),),
                            const Icon(Icons.place),
                          ],
                        ),

                      ],
                    ),
                      Padding(
                      padding:  const EdgeInsets.fromLTRB(0,5,0,15),
                      child: SizedBox(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: SingleChildScrollView(
                            child: Text(ongProfileController.ongInfo!['bio'])))),
                              SizedBox(
                                width: double.infinity,
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,   
                                  children: [
                                  Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children:[
                                  Column(
                                    children: ongProfileController.geraAnimalCardsUser(ongProfileController.petsInfo,0), // Use a função para gerar os cards             
                                  ),
                                  Column(
                                  children: ongProfileController.geraAnimalCardsUser(ongProfileController.petsInfo2,1) // Gere mais cards conforme necessário               
                                  ),
                                  ],
                                )
                              ],
                          ),
                        ),

                    ),
                    
                  ],
                  
                ),
              )
          ],
        );
                } else {
                  return const Text('Nenhum pet disponível');
                }
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
              } else {
                return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0),));
              }
            },
          ),
      );
    }  
    )
    );
  }
}


// ignore: must_be_immutable
class AnimalCard2 extends StatelessWidget {
  final VoidCallback onPressed;
  Map<String,dynamic> pet;
  double height;
  
  AnimalCard2({
    required this.onPressed,
    required this.pet,
    required this.height
  });

  ImageProvider<Object> convertBase64ToImageProvider(String base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context)  {
    String imagemPadrao = pet['tipo'] == '1' ? 'assets/exemplo1.png': 'assets/exemplo2.png';
    final imageProvider = pet['imagem'] != null ? convertBase64ToImageProvider(pet['imagem']):AssetImage(imagemPadrao);   
    return GestureDetector(
        onTap: onPressed,
        
          child: Container(
            width: 160,
            height: height,
            decoration: BoxDecoration(
                color:const  Color.fromARGB(255, 255, 250, 248),
                borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                ),
          
          ),
        
      
    );
  }
}
