// ignore_for_file: must_be_immutable
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/ongPages/insert_animal_page.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/home_page.dart';
import 'package:replica_google_classroom/App_pages/OngPages/perfilOng.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';


class PrincipaAppController extends GetxController {
  late SenhaController senhaController;
  var opcaoSelecionada = 0.obs;
  Color corItemSelecionado = const Color.fromARGB(255, 0, 0, 0);
  Color corItemNaoSelecionado = const  Color.fromARGB(255, 255, 255, 255);
  late String cpfUsuario;
  late String emailUsuario;
  File? imageFile;
  File? imageFeedFile;
  Map<String,dynamic>? usuario;

  Future<String> func() async{
    senhaController = Get.find(); // Encontra a instância existente
    //usuario = await MongoDataBase.retornaUsuarioCompleto(senhaController.email);
    cpfUsuario = await MongoDataBase.retornaCpf(senhaController.email);
    emailUsuario = senhaController.email;
    return 'allan';
  }


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

              body: FutureBuilder(
              future: principaAppController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Obx(
                    () => IndexedStack(
                      index: principaAppController.opcaoSelecionada.value,
                      children: <Widget>[
                        HomePage(),
                        InsertAnimalPage(),
                        SettingsPage(),
                      ],
                    ),
                );
                  } else {
                    return const Text('Nenhum pet dispongdfgfdgfdgfdgfdgfdgfível');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a listdfgfdgfdgfdgfdgfdga de pets: ${snapshot.error}');
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
          }),
    );
  }
}
