// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class OngEditBioPageController extends GetxController {
  var bioText = TextEditingController();
 

  @override
  void onInit() async {
    // Chamado quando o controller é inicializado
    bioText.text = Get.arguments[0];
    super.onInit();
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
                          showLoad(context);
                          await MongoDataBase.insereBioPerfil('allan.miller@upe.br',ongEditBioPageController.bioText.text);
                          print(ongEditBioPageController.bioText.text);
                          Get.back();
                          Get.toNamed('/ongProfilePage');
                          
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