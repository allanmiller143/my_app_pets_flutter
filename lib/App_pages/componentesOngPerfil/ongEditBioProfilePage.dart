// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/settings_page.dart';

//import 'package:replica_google_classroom/services/mongodb.dart';
//import 'package:replica_google_classroom/widgets/load_widget.dart';

class OngEditBioPageController extends GetxController {
  var bioText = TextEditingController();
  late SettingsPageController settingsController;

  @override
  void onInit() async {
    // Chamado quando o controller é inicializado
    settingsController = Get.find(); // Encontra a instância existente
    bioText.text = settingsController.bio.value;
    super.onInit();
  }

  void concluirEdicao() {
    settingsController.bio.value = bioText.text;
    Get.back(result: settingsController.bio);
  }
}

class OngEditBioProfilePage extends StatelessWidget {
  OngEditBioProfilePage({Key? key}) : super(key: key);
  final ongEditBioPageController = Get.put(OngEditBioPageController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<OngEditBioPageController>(
        init: OngEditBioPageController(),
        builder: (_) {
          return  Scaffold(
           body:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(5,15,5,0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.arrow_back_ios),                       
                      ),
                
                      const Text('Bio',style: TextStyle(fontSize: 18),),
                      TextButton(
                        onPressed: () async{
                          //showLoad(context);
                          //await MongoDataBase.insereBioPerfil('allan.miller@upe.br',ongEditBioPageController.bioText.text);
                          ongEditBioPageController.concluirEdicao();
                          Get.back();
                          //Get.toNamed('/ongProfilePage');

                        },
                         child: const Text('Concluir'))
                
                    ],
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Padding(
                padding: const EdgeInsets.all(16.0),
                  child: TextField(
                    controller: ongEditBioPageController.bioText,
                    maxLines: 3, // Define o número de linhas para ser nulo, permitindo múltiplas linhas
                    maxLength: 120,
                    decoration: const InputDecoration (
                      hintText: 'Insira sua Bio',
                      border: InputBorder.none,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                  height: 0,
                ),
              ],
            )
          );
        }
      )
    );
  }
}