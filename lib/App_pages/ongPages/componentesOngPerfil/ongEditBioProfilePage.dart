// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';

class OngEditBioPageController extends GetxController {
  var bioText = TextEditingController();
  late SettingsPageController settingsController;
  late MeuControllerGlobal meuControllerGlobal;

  @override
  void onInit() async {
    // Chamado quando o controller é inicializado
    settingsController = Get.find(); // Encontra a instância existente
    meuControllerGlobal = Get.find();
    bioText.text = settingsController.bio.value;
    super.onInit();
  }

  Future<void> concluirEdicao() async{
    settingsController.bio.value = bioText.text;
    meuControllerGlobal.usuario['Bio'] = bioText.text;

    Get.back();

    await BancoDeDados.adicionarInformacoesUsuario({'Bio' : bioText.text}, meuControllerGlobal.usuario['Id']);

  }
}

class OngEditBioProfilePage extends StatelessWidget {
  OngEditBioProfilePage({super.key});
  final ongEditBioPageController = Get.put(OngEditBioPageController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<OngEditBioPageController>(
        init: OngEditBioPageController(),
        builder: (_) {
          return  Scaffold(
             appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title:const Text(
                'Bio',
                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              
            ),
           body:Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(        
                    maxLength: 150,
                    controller: ongEditBioPageController.bioText,
                    maxLines: 3, // Define o número de linhas para ser nulo, permitindo múltiplas linhas
                   
                    decoration: InputDecoration(
                      border: const UnderlineInputBorder(borderSide: BorderSide.none),
                      
                      contentPadding:const EdgeInsets.fromLTRB(8,0,8,0),
                      labelText: 'Bio',
                      labelStyle: const TextStyle(fontSize: 14),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear,size: 18,),
                        onPressed:(){
                          ongEditBioPageController.bioText.clear();
                        },
                        
                      ),
                    ),
                  ),
                ),
                const Padding(
                  padding:  EdgeInsets.fromLTRB(15.0, 5, 10.0, 15),
                  child: Text('Bio é uma breve descrição pessoal, resumindo quem você é e seus interesses.',
                    style: TextStyle(fontSize: 16.0, color: Colors.grey),
                  ),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width *0.5,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 255, 84, 16)
                      ),
                      onPressed: () {
                          ongEditBioPageController.concluirEdicao();
                      },      
                      
                      child:  const Text('Concluir',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),)
                    ),
                  ),
                
              ],
            )
          );
        }
      )
    );
  }
}