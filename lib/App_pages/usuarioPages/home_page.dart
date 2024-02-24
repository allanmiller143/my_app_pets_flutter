// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';
import '../app_widgets/my_custom_card_home_page.dart';
import '../app_widgets/my_animal_card.dart';

class HomePageController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  File? imageFile; // imagem para ser coletada e inserida no banco para o perfil 
  RxInt alterarImagem = 1.obs;

  List<Map<String, dynamic>> pets = [];
  dynamic usuario;

  @override
  void onInit(){
    super.onInit();
    meuControllerGlobal = Get.find();
    usuario = meuControllerGlobal.usuario;

  }


  alteraLista() async {
    if(meuControllerGlobal.internet.value == true){
      meuControllerGlobal.petsSistema = await BancoDeDados.obterPets();
      pets = meuControllerGlobal.petsSistema;
      return pets;
    }
  }

   void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      await BancoDeDados.saveImageToFirestore(imageFile!, meuControllerGlobal.usuario['Id'],meuControllerGlobal.usuario['ImagemPerfil']);
      alterarImagem ++;
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
                title: const Text(
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
                leading: const Icon(
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

   void mostrarDialogoDeConfirmacao(context) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title:const  Text('Excluir conta'),
            content: const Text('Tem certeza que deseja excluir a conta?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () async{
                  await BancoDeDados.excluirConta(meuControllerGlobal.usuario['Id']);
                  
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop(); // Fecha o dialogo

                  Get.toNamed('/');
                },
                child: const  Text('Confirmar'),
              ),
            ],
          );
        },
      );
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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              forceMaterialTransparency: true,
              toolbarHeight: 85,

            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                   UserAccountsDrawerHeader(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 255, 51, 0),
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10) 
                      )
                    ),
                    accountName:  Text(homePageController.meuControllerGlobal.usuario['Nome']),
                    accountEmail:  Text(homePageController.meuControllerGlobal.usuario['E-mail']),
                    currentAccountPicture: Obx(
                      () => homePageController.alterarImagem.value != 0 ? CircleAvatar(
                        backgroundImage: homePageController.meuControllerGlobal.usuario['ImagemPerfil'] == '' ?
                          AssetImage('assets/eu.png'):
                          NetworkImage(homePageController.meuControllerGlobal.usuario['ImagemPerfil'] ) as ImageProvider<Object>,
                      
                        radius: 30, // ajuste conforme necessário
                      ): SizedBox()
                    ),
                    currentAccountPictureSize:  Size(60, 60),
                    
                  ),
                  ListTile(
                    leading:const Icon(Icons.favorite),
                    title: const Text('Favoritos'),
                    onTap: () {
                      Get.toNamed('/favorits');
                     
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo),
                    title: const Text('Inserir Foto de Perfil'),
                    onTap: () {
                      homePageController.showBottomSheet(context);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.pets),
                    title: const Text('Suas adoções'),
                    onTap: () {
                      Get.toNamed('/adocoesUsuario');
                     
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.edit),
                    title: const  Text('Alterar Informações'),
                    onTap: () {
                      if(homePageController.meuControllerGlobal.usuario['Data'] == true){
                        Get.toNamed('/alterarPage');
                      }
                      else{
                        mySnackBar('Você ainda não cadastrou suas informações', false);
                      }
                    }
                  ),
                  ListTile(
                    leading:const  Icon(Icons.delete,color: Colors.red,),
                    title:const  Text('Excluir Conta',style: TextStyle(color: Colors.red),),
                    onTap: () {
                      homePageController.mostrarDialogoDeConfirmacao(context);
                    },
                  ),
                ],
              ),
            ),
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
                                      height: MediaQuery.of(context).size.width *0.35,
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
                                            child: Padding(
                                              padding: const EdgeInsets.fromLTRB(10,0,10,10),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  homePageController.pets.isNotEmpty ?
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                  child: AnimalCard(
                                                    pet: homePageController.pets[0],
                                                    onPressed: () {
                                                      Get.toNamed('/animalDetail', arguments: [homePageController.pets[0],homePageController.usuario]);       
                                                            
                                                      //Get.toNamed('/animalDetail', arguments: [homePageController.pets[0],homePageController.usuario]);       
                                                    },
                                                    meuControllerGlobal: homePageController.meuControllerGlobal,
                                                            
                                                  ),
                                                ): Text('Estamos sem nenhum pet no sistema'),
                                                homePageController.pets.length > 1 ?
                                                Padding(
                                                  padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                  child: AnimalCard(
                                                    pet: homePageController.pets[1],
                                                    onPressed: () {
                                                      Get.toNamed('/animalDetail', arguments: [homePageController.pets[1],homePageController.usuario]);
                                                    },     
                                                    meuControllerGlobal: homePageController.meuControllerGlobal,
                                                            
                                                  ),
                                                ):SizedBox(),
                                                homePageController.pets.length > 2 ?
                                                AnimalCard(
                                                  pet: homePageController.pets[2],
                                                  onPressed: () {
                                                    Get.toNamed('/animalDetail', arguments: [homePageController.pets[2],homePageController.usuario]);    
                                                  },
                                                  meuControllerGlobal: homePageController.meuControllerGlobal,
                                                ):SizedBox(),

                                                ],
                                              ),
                                            ),
                                            
                                          ),
                                        ),
                                        Text('wq')
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
