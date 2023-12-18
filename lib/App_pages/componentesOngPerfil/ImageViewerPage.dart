// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/componentesOngPerfil/imageFeedDetail.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/settings_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class ImageViewerController extends GetxController {
  var imagem = Get.arguments[0];
  late  SettingsPageController settingsController;

  @override
  void onInit() {
    settingsController = Get.find(); // Encontra a instância existente
    super.onInit();
  }

  void excluir() async{
    settingsController.info.remove(imagem);
    settingsController.nunmeroDePostagens.value -=1;
    settingsController.opcao.value = 1;
    settingsController.opcao.value = 0;
    Get.back();Get.back();
    await MongoDataBase.apagaDocumento('feedImagens', imagem, settingsController.emailOng);
    
  }
  

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // Conteúdo do BottomSheet
          height: 100,
          child: Column(
            children: [
             
              ListTile(
                title: const Text(
                  'Excluir',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.delete_outline,
                  color: Color.fromARGB(255, 199, 5, 5),
                ),
                onTap: () {
                  excluir();
                },
              ),
            
            ],
          ),
        );
      },
    );
  }
  
 
}

class ImageViewerPage extends StatelessWidget {
  ImageViewerPage({super.key});
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
                    height: MediaQuery.of(context).size.width * 0.16,
                    color:const Color.fromARGB(255, 0, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adicionado alinhamento
                      children: [
                        IconButton(onPressed: (){Get.back();}, icon:const  Icon(Icons.arrow_back_ios_new,color:  Color.fromARGB(255, 255, 255, 255))),
                        const Text('Publicação',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),),
                        const SizedBox(width: 48), // Espaço para alinhar o texto "Publicação" no centro
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.0001,
                    color: const Color.fromARGB(255, 255, 255, 255),
                    
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width * 0.15,
                    color: const Color.fromARGB(255, 255, 73, 1),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(10,0,0,0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adicionado alinhamento
                        children: [
                          Row(
                            children: [
                              Container(
                                width:  MediaQuery.of(context).size.width * 0.1,
                                height: MediaQuery.of(context).size.width * 0.1,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: const Color.fromARGB(255, 255, 255, 255),
                                ),
                                
                              ),
                              const Padding(
                                padding:  EdgeInsets.all(8.0),
                                child: Text('Ong dos Animais',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),),
                              ),
                            ],
                          ), 
                          IconButton(onPressed: (){imageViewerController.showBottomSheet(context);}, icon:const Icon(Icons.menu_sharp,color:  Color.fromARGB(255, 255, 255, 255))),
                          
                        ],
                      ),
                    ),
                  ),
                  FeedDetail(imagembd: imageViewerController.imagem),
                  
              ],
            )
          );
        },
      ),
    );
  }
}
