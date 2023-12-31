
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class UserDataPageController extends GetxController {
  late SenhaController senhaController;
  RxString rua = ''.obs;
  late String nomeTelefone;
  late String localizacao;
  
  @override
  void onInit() {
    senhaController = Get.find();
    // verificar se o usuario ja possui dados cadastrados no sistema, se sim, essa tela vai ser de alteração, se nap se inserção
    rua.value = '${senhaController.usuario['rua']} - ${senhaController.usuario['numero']}';
    nomeTelefone = '${senhaController.usuario['nome completo']} - ${senhaController.usuario['telefone']}';
    localizacao = '${senhaController.usuario['cidade']}, ${senhaController.usuario['estado']} - ${senhaController.usuario['cep']}';
    super.onInit();
  }
  
  
 
}
// ignore: must_be_immutable
class UserDataPage extends StatelessWidget {
  UserDataPage({super.key});

  var userDataPageController = Get.put(UserDataPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: const Color.fromARGB(255, 250, 63, 6),
          centerTitle: true,
          title: const Text(
            'Seus dados',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height *0.85,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
            child:  Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  child: Card(
                    elevation: 2,
                      child: Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height * 0.2,
                        padding:const EdgeInsets.fromLTRB(30, 10, 15, 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: const Color.fromARGB(255, 255, 255, 255),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(()=> Text(userDataPageController.rua.value,style: const TextStyle(fontSize: 16,fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,)),
                            Text(userDataPageController.localizacao,style:const TextStyle(color: Color.fromARGB(172, 103, 93, 70),fontSize: 13,fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            Text(userDataPageController.nomeTelefone,style:const TextStyle(color: Color.fromARGB(172, 103, 93, 70),fontSize: 13,fontWeight: FontWeight.w400),maxLines: 1,overflow: TextOverflow.ellipsis,),
                            const Divider( ),
                            GestureDetector(
                              onTap: () {
                                Get.back();
                                Get.toNamed('/insertUserDataPage',arguments: ['Alterar dados','Altere os dados necessários']);
                              },
                              child:const  Text('Editar', style: TextStyle(color:Colors.blue),)
                            ),
                            const Divider(),
                            GestureDetector(
                              onTap:() { 
                                print('abrir bottomsheet');
                              },
                              child: const Text('Apagar informações', style: TextStyle(color:Colors.blue),)
                            ),
                          ],
                          
                        ),
                      ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                  child: CustomIconButton(
                    label: 'Continuar',
                    onPressed: () {
                    },
                    width: 250,
                    alinhamento: MainAxisAlignment.center,
                  ),
                )
              ],
            ),
            
          ),
          
        ),
      
    );
  }
}
