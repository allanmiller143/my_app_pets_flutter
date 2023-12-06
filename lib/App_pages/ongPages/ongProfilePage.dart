import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import '../app_widgets/pet_register_widgets/photo_container.dart';


class OngProfileController extends GetxController {
  static OngProfileController get to => Get.find(); 
  Map<String,dynamic>? ongInfo;
  List<Map<String, dynamic>> ongPets = [];
  List<String> favoritPetIds = [];
  List<Map<String, dynamic>> petsInfo = [];
  List<Map<String, dynamic>> petsInfo2 = [];
  File? imageFile;

  int tipo = Get.arguments[1];

  Future<List<Map<String,dynamic>>> alteraLista() async {
    favoritPetIds = [];
    favoritPetIds = await MongoDataBase.retornaPetIds('12678032400');
    ongPets = await MongoDataBase.retornaListaPetsOng('48659836000129');
    ongInfo = await MongoDataBase.retornaOngCompleta('allan.miller@upe.br');

    return ongPets;
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
               Get.toNamed('/animalDetail', arguments: [ongPets[p],favoritPetIds]); 
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
        return Container(
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
                leading: Icon(
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
        return Container(
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
                leading: Icon(
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



class OngProfilePage extends StatelessWidget {
  OngProfilePage({Key? key}) : super(key: key);
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
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.3,
                    
                  ),
                  Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.21,
                    decoration: const BoxDecoration(
                      image: DecorationImage(image: AssetImage('assets/fundoOngProfile.png'),fit: BoxFit.cover)
                    ),
                  ),  

                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.05,
                    left:  MediaQuery.of(context).size.width * 0.05,
                    child: IconButton( onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios_new,color: const Color.fromARGB(255, 255, 255, 255)),)
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.12,
                    left:  MediaQuery.of(context).size.width * 0.05,
                    child: PhotoContainer(onPressed: (){ ongProfileController.showBottomSheet(context);}, image: ongProfileController.imageFile,imagembd: ongProfileController.ongInfo!['imagemPerfil'],tipo: ongProfileController.tipo,),
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
                            color: Color.fromARGB(255, 107, 106, 104),
                            borderRadius: BorderRadius.circular(5) 
                          ),
                          child: Center(child: Text('Editar Perfil',style: TextStyle(color: const Color.fromARGB(255, 255, 255, 255)),)),
                        ),
                    ),
                  ):SizedBox(),
                ]   
              ),
               Padding(
                padding: const EdgeInsets.fromLTRB(25,10,25,0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Ong dos animais',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700)),
                        Row(
                          children: [
                            Text('Surubim, PE',style: TextStyle(fontWeight: FontWeight.w200),),
                            Icon(Icons.place),
                          ],
                        ),

                      ],
                    ),
                      Padding(
                      padding:  const EdgeInsets.fromLTRB(0,5,0,15),
                      child: Container(
                          height: MediaQuery.of(context).size.height * 0.06,
                          child: SingleChildScrollView(
                            child: Text(ongProfileController.ongInfo!['bio'])))),
                    

                    Container(
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
                          children: ongProfileController.generateAnimalCards(ongProfileController.petsInfo,0), // Use a função para gerar os cards             
                        ),
                        Column(
                        children: ongProfileController.generateAnimalCards(ongProfileController.petsInfo2,1) // Gere mais cards conforme necessário               
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
    }  
    )
    );
  }
}


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
