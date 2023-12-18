// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/home_page.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/pets_page.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/settings_page.dart';
import '../app_widgets/pet_register_widgets/photo_container.dart';


class PrincipaAppController extends GetxController {
  static PrincipaAppController get to => Get.find();
  var opcaoSelecionada = 0.obs;
  Color corItemSelecionado = Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = Color.fromARGB(255, 255, 255, 255);
  String cpfUsuario = '12678032400';
  String emailUsuario = 'millerallan17@gmail.com';
  File? imageFile;
  File? imageFeedFile;
  int tipo = 1;

  Map<String,dynamic>? usuario;

  void mudaOpcaoSelecionada(int index) {
    opcaoSelecionada.value = index;
  }

  void pick(ImageSource source, File? imagem) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imagem = File(pickedFile.path);
      update();
    }
  }
  void showBottomSheet(BuildContext context,File? imagem) {
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
                leading:const  Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.gallery, imagem);
                },
              ),
              ListTile(
                title: const Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const  Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.camera,imagem);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}


class MyPrincipalAppPage extends StatelessWidget {
  MyPrincipalAppPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var principaAppController = PrincipaAppController();
    return MaterialApp(
      home: GetBuilder<PrincipaAppController>(
          init: PrincipaAppController(),
          builder: (_) {
            return Scaffold(
              extendBodyBehindAppBar: true,
              
              drawer:  Drawer(

                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10,20,10,0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              //PhotoContainer(onPressed: (){principaAppController.showBottomSheet(context);}, image: principaAppController.imageFile,),
                            ],
                          ),
                           Padding(
                            padding: EdgeInsets.fromLTRB(0,5,0,0),
                            child:  Text('Allan Miller',style: TextStyle(fontSize: 22),),
                          ),
                        ],
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding:  EdgeInsets.fromLTRB(10,40,0,10),
                            child:  Text('Opções',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                          ),
                          Divider(
                            thickness: 1, // Espessura da linha
                            color: Colors.black, // Cor da linha
                            height: 5, // Altura da linha
                          )
                        ],
                      ),
                      ListTile(
                        leading: const Icon(Icons.favorite),
                        title:const  Text('Pets favoritos'),
                        onTap: (){
                          Get.toNamed('/favorits',arguments: [principaAppController.cpfUsuario,principaAppController.emailUsuario]);
                        },
                      ),
                      const ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Perfil'),
                      ),
                      const ListTile(
                        leading: Icon(Icons.favorite),
                        title: Text('alguma coisa'),
                      ),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding:  EdgeInsets.fromLTRB(10,20,0,10),
                            child:  Text('Configurações',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w700),),
                          ),
                          Divider(
                            thickness: 1, // Espessura da linha
                            color: Colors.black, // Cor da linha
                            height: 5, // Altura da linha
                          )
                        ],
                      ),

                    ],
                  ),
                ),
              ),
              appBar: AppBar(
                forceMaterialTransparency: true,
                toolbarHeight: 85,
              ),
              bottomNavigationBar: Obx(
                () => Container(
                  decoration: const BoxDecoration(
                      border: Border(top: BorderSide(width: 0.1, color: Colors.black))),    
                  child: BottomNavigationBar(
                    elevation: 8,
                    onTap: (index) {
                      principaAppController.mudaOpcaoSelecionada(index);
                    },
                    type: BottomNavigationBarType.fixed,
                    currentIndex: principaAppController.opcaoSelecionada.value,
                    backgroundColor: Color.fromARGB(255, 255, 51, 0),
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.pets_outlined),
                        label: 'Pets',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.settings),
                        label: 'Settings',
                      ),
                    ],
                    selectedItemColor: principaAppController.corItemSelecionado,
                    unselectedItemColor:principaAppController.corItemNaoSelecionado,
                  ),
                ),
              ),
              body: Obx(
                () => IndexedStack(
                  index: principaAppController.opcaoSelecionada.value,
                  children: <Widget>[
                    HomePage(),
                    PetsPage(),
                    SettingsPage(),
                  ],
                ),
              ),
            );
          }),
    );
  }
}
