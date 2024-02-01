// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/imageFeedDetail.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class ImageViewerController extends GetxController {
  dynamic imagem;
  dynamic tipo = Get.arguments[1];
  late SettingsPageController settingsController;
  late MeuControllerGlobal meuControllerGlobal;
  dynamic info = [];

  @override
  void onInit() {
    settingsController = Get.find(); // Encontra a instância existente
    meuControllerGlobal = Get.find();

    if (Get.arguments[1] == 2) {
      imagem = Get.arguments[0]['Imagem'];
      info = Get.arguments[0];
    } else {
      imagem = Get.arguments[0]['Imagem'];
      info = Get.arguments[0];
    }
    super.onInit();
  }

  void excluir() async {
    settingsController.info.remove(info);
    meuControllerGlobal.usuario['Imagens feed'].remove(info);
    settingsController.nunmeroDePostagens.value -= 1;
    settingsController.opcao.value = 1;
    settingsController.opcao.value = 0;
    Get.back();
    Get.back();
    await BancoDeDados.removerFotoFeed(meuControllerGlobal.usuario['Id'], info['Id animal'], info['Imagem']);
  }

  void excluirPet() async {

    if(info['Em processo de adoção'] == false){
      settingsController.petsInfo.remove(info);
      meuControllerGlobal.pets.remove(info);
      meuControllerGlobal.usuario['Pets'].remove(info);
      settingsController.opcao.value = 1;
      settingsController.opcao.value = 0;
      Get.back();
      Get.back();
      await BancoDeDados.removerPet(meuControllerGlobal.usuario['Id'],info['Id animal'],info['Imagem']);
    }
    else{
      mySnackBar('Esse pet está em processo de adoção, para excluir ele, conclua o processo primeiro!!!', false);
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
                  'Editar',
                  style: TextStyle(
                    fontSize: 25,
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'AsapCondensed-Medium',
                  ),
                ),
              ),
              ListTile(
                title: const Text(
                  'Excluir',
                  style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontFamily: 'AsapCondensed-Medium',
                  ),
                ),
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color.fromARGB(255, 199, 5, 5),
                ),
                onTap: () {
                  tipo == 1 ? excluir() : excluirPet();
                },
              ),
              tipo == 2
                  ? ListTile(
                      title: const Text(
                        'Editar informações',
                        style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'AsapCondensed-Medium',
                        ),
                      ),
                      leading: const Icon(
                        Icons.delete_outline,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                      onTap: () {
                        var infoEditavel = {
                          'Nome animal': info['Nome animal'],
                          'Idade': info['Idade'],
                          'Raça':info['Raça'],
                          'Tipo': info['Tipo animal'],
                          'Sexo' : info['Sexo'],
                          'Porte' : info['Porte'],
                          'Imagem': info['Imagem'],
                          
                        };
                        Get.toNamed('/OngInfoEditPage', arguments: [infoEditavel, info['Id animal']]);
                      },
                    )
                  : const SizedBox()
            ],
          ),
        );
      },
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  ImageViewerPage({Key? key});
  final imageViewerController = Get.put(ImageViewerController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<ImageViewerController>(
        init: ImageViewerController(),
        builder: (_) {
          return Scaffold(
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: Text(
                imageViewerController.meuControllerGlobal.usuario['Nome'],
                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              actions: [
                imageViewerController.settingsController.args == false ?
                  IconButton(onPressed: () => imageViewerController.showBottomSheet(context), icon: const Icon(Icons.menu_sharp, color: Color.fromARGB(255, 255, 255, 255))):
                  IconButton(onPressed: () {}, icon: const Icon(Icons.menu_sharp, color: Color.fromARGB(255, 255, 255, 255)))
              ],
           ),
            body: Column(
              children: [
                imageViewerController.tipo == 2 ?
                FeedDetail(imagembd: imageViewerController.imagem,tipoPet: imageViewerController.info['tipo animal'],):
                FeedDetail(imagembd: imageViewerController.imagem),
              ],
            ),
          );
        },
      ),
    );
  }
}
