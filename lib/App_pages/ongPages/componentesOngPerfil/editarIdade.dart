import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/OngInfoEditPage.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/App_pages/ongPages/listas.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/pet_register_widgets/drop_down.dart';

class EditarCampoIdadeController extends GetxController {
  String chave = Get.arguments[0];
  String chaveAux = Get.arguments[0]; 
  dynamic valor = Get.arguments[1];
  RxInt ativado = 0.obs;
  late SettingsPageController settingsController;
  late MeuControllerGlobal meuControllerGlobal;
  String petId = Get.arguments[2];
  dynamic lista = idades;
  var selectedAge = 'Idade'.obs;
  var selectedRace = 'Raça'.obs;
  var selectedType = 'Tipo'.obs;
  var selectedSex = 'Sexo'.obs;
  var selectedPorte = 'Porte'.obs;
  var x = ''.obs;
 
  late OngInfoEditPageController ongInfoEditPageController;
  
  Future<String> func() async {
    ongInfoEditPageController= Get.find(); 
    meuControllerGlobal = Get.find();
    meuControllerGlobal = Get.find();
    if(chave == 'Idade'){
      lista = idades;
      x = selectedAge;
    }else if(chave == 'Raça'){
      if(ongInfoEditPageController.infoEditavel['Tipo'] == '1'){
        lista = racasDeCachorro;
      }
      else if(ongInfoEditPageController.infoEditavel['Tipo'] == '2'){
        lista = racasDeGato;
      }
      else{
        lista = avesDeEstimacao;
      }
      x = selectedRace;
    }else if(chave == 'Tipo'){
      x = selectedType;
      lista = tipoList;
    }else if(chave == 'Sexo'){
      x = selectedSex;
      lista = sexoList;
    }else if(chave == 'Porte'){
      x = selectedPorte;
      lista = portes;
    }

    settingsController = Get.find(); // Encontra a instância existente
    return 'allan';
  }

  Future<void> validar() async{
    for (int i = 0; i < settingsController.usuario['Pets'].length; i++) {
      if (settingsController.usuario['Pets'][i]['Id'] == petId) {
        settingsController.usuario['Pets'][i][chave] = x.value;
        meuControllerGlobal.usuario['Pets'][i][chave] = x.value;
        break;
      }
    }
    Get.back();Get.back();Get.back();Get.back();

    await BancoDeDados.alterarPetInfo({chave: x.value},meuControllerGlobal.usuario['Id'], petId);

  }
}


// ignore: must_be_immutable
class EditarCampoIdadePage extends StatelessWidget {
  EditarCampoIdadePage({super.key});
  var editarCampoIdadeController = Get.put(EditarCampoIdadeController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EditarCampoIdadeController>(
        init: EditarCampoIdadeController(),
        builder: (_) {
          return Scaffold(
             appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: Text(
                editarCampoIdadeController.chave,
                style: const TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              
            ),
            body: FutureBuilder(
              future: editarCampoIdadeController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
                          Row(
                            children: [
                              
                               const Padding(
                                padding:  EdgeInsets.fromLTRB(5, 5, 5, 5),
                                child: Text(
                                  'Selecione: ',
                                  style: TextStyle(fontSize: 16.0,),
                                ),
                              ),
                              CustomDropdownButton(items: editarCampoIdadeController.lista, controller: editarCampoIdadeController.x),
                            ],
                          ),
                           
                          Obx(
                            ()=> SizedBox(
                              width: MediaQuery.of(context).size.width *0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: editarCampoIdadeController.x.value == editarCampoIdadeController.chave ? Colors.black12 :const Color.fromARGB(255, 255, 84, 16)
                                ),
                                onPressed: () {
                                  editarCampoIdadeController.x.value == editarCampoIdadeController.chaveAux? print('botao Desativado') : editarCampoIdadeController.validar();
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
