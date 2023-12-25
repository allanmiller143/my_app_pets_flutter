import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:replica_google_classroom/widgets/load_Widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/OngPages/perfilOng.dart';
import 'package:replica_google_classroom/services/mongodb.dart';



class EditarCampoImagemController extends GetxController {
  String chave = Get.arguments[0]; 
  dynamic valor = Get.arguments[1];
  RxInt ativado = 0.obs;
  late SettingsPageController settingsController;
  String petId = Get.arguments[2];
  File? imageFile; // imagem para ser coletada e inserida no banco
  late String base64Image;
  

  
  Future<String> func() async {

    settingsController = Get.find(); // Encontra a instância existente
    return 'allan';
  }

  Future<void> validar() async{
     for (int i = 0; i < settingsController.usuario['petList'].length; i++) {
          if (settingsController.usuario['petList'][i]['id'] == petId) {
            settingsController.usuario['petList'][i]['imagem'] = base64Image;
            break;
          }
        }

        settingsController.opcao.value = 0;
        settingsController.opcao.value = 1;
        Get.back();Get.back();Get.back();Get.back();
    await MongoDataBase.alteraPet('imagem', base64Image, settingsController.emailOng, petId);
  }

  void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile!.readAsBytes(); // Converta a imagem em um array de bytes 
      base64Image = base64Encode(imageBytes); // Codifique os bytes em formato base64 (opcional)
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
            body: FutureBuilder(
              future: editarCampoImagemController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            color: const Color.fromARGB(255, 255, 84, 16),
                            padding: const EdgeInsets.fromLTRB(0,15,0,0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adicionado alinhamento
                              children: [
                                IconButton(
                                  iconSize: 18,
                                  onPressed:(){
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios,color: Color.fromARGB(255, 255, 255, 255)),                       
                                ),
                                Text(editarCampoImagemController.chave,style: const TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255)),),
                                const SizedBox(width: 48), // Espaço para alinhar o texto "Publicação" no centro
                              ],
                            ),
                          ),
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
                                   editarCampoImagemController.ativado.value == 0 ? print(editarCampoImagemController.imageFile) : editarCampoImagemController.validar();
                                },      
                                
                                child:  const Text('Concluir',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),)
                              ),
                            ),
                          ),
                        ], 
                      ),
                    );
                  } else {
                    return Text('Nenhum pet disponível');
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
