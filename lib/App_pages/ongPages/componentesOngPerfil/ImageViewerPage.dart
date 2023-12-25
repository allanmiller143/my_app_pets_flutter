// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/imageFeedDetail.dart';
import 'package:replica_google_classroom/App_pages/OngPages/perfilOng.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class ImageViewerController extends GetxController {
  dynamic imagem;
  dynamic tipo = Get.arguments[1];
  late SettingsPageController settingsController;
  dynamic info = [];

  @override
  void onInit() {
    settingsController = Get.find(); // Encontra a instância existente

    if (Get.arguments[1] == 2) {
      imagem = Get.arguments[0]['imagem'];
      info = Get.arguments[0];
    } else {
      imagem = Get.arguments[0];
    }
    super.onInit();
  }

  void excluir() async {
    settingsController.info.remove(imagem);
    settingsController.nunmeroDePostagens.value -= 1;
    settingsController.opcao.value = 1;
    settingsController.opcao.value = 0;
    Get.back();
    Get.back();
    await MongoDataBase.apagaDocumento('feedImagens', imagem, settingsController.emailOng);
  }

  void excluirPet() async {
    settingsController.petsInfo.remove(info);
    settingsController.opcao.value = 1;
    settingsController.opcao.value = 0;
    Get.back();
    Get.back();
    await MongoDataBase.removePet(settingsController.emailOng, info['id']);
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
                          'Nome animal': info['nome'],
                          'Idade': info['idade'],
                          'Raça':info['raca'],
                          'Tipo': info['Tipo'],
                          'Sexo' : info['sexo'],
                          'Porte' : info['porte'],
                          'Imagem': info['imagem'],
                          
                        };
                        Get.toNamed('/OngInfoEditPage', arguments: [infoEditavel, info['id']]);
                      },
                    )
                  : SizedBox()
            ],
          ),
        );
      },
    );
  }
}

class ImageViewerPage extends StatelessWidget {
  ImageViewerPage({Key? key});
  final imageViewerController = Get.put(ImageViewerController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<ImageViewerController>(
        init: ImageViewerController(),
        builder: (_) {
          return Scaffold(
            body: Column(
              children: [
    
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.1,
                  color: const Color.fromARGB(255, 255, 73, 1),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                       IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Ong dos Animais', style: TextStyle(fontSize: 16,color: Color.fromARGB(255, 255, 255, 255))),
                        ),
                        IconButton(
                          onPressed: () => imageViewerController.showBottomSheet(context), icon: const Icon(Icons.menu_sharp, color: Color.fromARGB(255, 255, 255, 255))),
                      ],
                    ),
                  ),
                ),
                imageViewerController.tipo == 2 ?
                FeedDetail(imagembd: imageViewerController.imagem,tipoPet: imageViewerController.info['tipo'],):
                FeedDetail(imagembd: imageViewerController.imagem),
              ],
            ),
          );
        },
      ),
    );
  }
}
