
// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class UserDataPageController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  var ongPetInfo = Get.arguments[0];
  RxString rua = ''.obs;
  late String nomeTelefone;
  late String localizacao;
  
  @override
  void onInit() {
    meuControllerGlobal = Get.find();
    // verificar se o usuario ja possui dados cadastrados no sistema, se sim, essa tela vai ser de alteração, se nap se inserção
    rua.value = '${meuControllerGlobal.usuario['Rua']} - ${meuControllerGlobal.usuario['Numero']}';
    nomeTelefone = '${meuControllerGlobal.usuario['Nome completo']} - ${meuControllerGlobal.usuario['Telefone']}';
    localizacao = '${meuControllerGlobal.usuario['Cidade']}, ${meuControllerGlobal.usuario['Estado']} - ${meuControllerGlobal.usuario['cep']}';
    super.onInit();
  }


  criaIdAdocao(String a,String b){
    if(a.substring(0,1).codeUnitAt(0) > b.substring(0,1).codeUnitAt(0)){
      return "$b\_$a";
    }else{
      return "$a\_$b";
    }
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
                                Get.toNamed('/insertUserDataPage',arguments: ['Alterar dados','Altere os dados necessários',userDataPageController.ongPetInfo]);
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
                    onPressed: () async {
                      String b ='${userDataPageController.ongPetInfo['Id']}-${userDataPageController.ongPetInfo['Id animal']}';
                      String id = userDataPageController.criaIdAdocao(userDataPageController.meuControllerGlobal.usuario['Id'], b);
                      
                      var info = {
                        'Id adoção' : id,
                        'Id usuario' : userDataPageController.meuControllerGlobal.usuario['Id'],
                        'Id ong' : userDataPageController.ongPetInfo['Id'],
                        'Id animal': userDataPageController.ongPetInfo['Id animal'],
                        'Hora adoção': FieldValue.serverTimestamp(),
                        'Status': 'Aguardando avalição dos dados'
                      };
                      await BancoDeDados.adotar(id, info);

                      //Get.toNamed('/principalAppPage');
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
