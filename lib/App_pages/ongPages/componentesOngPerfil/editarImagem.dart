// ignore_for_file: avoid_print

import 'dart:io';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/load_Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';


class EditarCampoImagemController extends GetxController {
  String chave = Get.arguments[0]; 
  dynamic valor = Get.arguments[1];
  RxInt ativado = 0.obs;
  late SettingsPageController settingsController;
  late MeuControllerGlobal meuControllerGlobal;
  String petId = Get.arguments[2];
  File? imageFile; // imagem para ser coletada e inserida no banco

  

  
  Future<String> func() async {
    meuControllerGlobal = Get.find();
    settingsController = Get.find(); // Encontra a instância existente
    return 'allan';
  }

  Future<void> validar(context) async{
      showLoad(context);
      await BancoDeDados.alterarPetInfo( {'Imagem': imageFile, 'url': valor}, meuControllerGlobal.usuario['Id'], petId);
      Get.back();
      settingsController.opcao.value = 0;
      settingsController.opcao.value = 1;
      Get.back();Get.back();Get.back();Get.back();
       
  }

  void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      ativado.value = 1;
      mySnackBar('Imagem coletada com sucesso, clique em confirmar para continuar', true);
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
}


// ignore: must_be_immutable
class EditarCampoImagemPage extends StatelessWidget {
  EditarCampoImagemPage({super.key});
  var editarCampoImagemController = Get.put(EditarCampoImagemController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EditarCampoImagemController>(
        init: EditarCampoImagemController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: Text(
                editarCampoImagemController.chave,
                style: const TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              
            ),
            body: FutureBuilder(
              future: editarCampoImagemController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          Column(
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
                                  editarCampoImagemController.pick(ImageSource.gallery);
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
                                  editarCampoImagemController.pick(ImageSource.camera);
                                },
                              ),
                            ],
                          ),
                           
                          Obx(
                            ()=> SizedBox(
                              width: MediaQuery.of(context).size.width *0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: editarCampoImagemController.ativado.value == 0 ? Colors.black12 :const Color.fromARGB(255, 255, 84, 16)
                                ),
                                onPressed: () {
                                   editarCampoImagemController.ativado.value == 0 ? print(editarCampoImagemController.imageFile) : editarCampoImagemController.validar(context);
                                },      
                                
                                child:  const Text('Concluir',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),)
                              ),
                            ),
                          ),
                        ], 
                      ),
                    );
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
