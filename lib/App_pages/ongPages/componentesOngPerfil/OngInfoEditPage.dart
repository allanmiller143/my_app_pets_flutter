import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class OngInfoEditPageController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  dynamic usuario;
  dynamic infoEditavel; 
  late String petId;

  Future<String> func() async {
    meuControllerGlobal = Get.find(); // Encontra a instância existente
    usuario = meuControllerGlobal.usuario;
    infoEditavel = Get.arguments[0];
    if(Get.arguments.length > 1 && Get.arguments[1] != null){
      petId = Get.arguments[1];
    }else{
      print('entrei kaidsugfiudsf');
      petId = '';
    }
    print('petid: $petId');
    return 'allan';
  }

List<Widget> campoEditar(BuildContext context, ) {
  List<Widget> rows = [];

  infoEditavel.forEach((String key, dynamic item) {
    Widget row;
    // Abre uma tela de edição simples
    row = Padding(
      padding: const EdgeInsets.fromLTRB(0,0,10,0),
      child: ListTile(
          title:Text('$key'), 
          subtitle: Text('${item}'),
          trailing: Icon(Icons.arrow_drop_down),
          onTap: (){
            if(petId.isNotEmpty){
              if(key == 'Idade' || key == 'Raça' || key == 'Porte' || key == 'Sexo'){
                print('indo para rota de editar nome');
                Get.toNamed('/editarIdade',arguments: [key,item,petId]);
              }
              else if(key == 'Imagem'){
                Get.toNamed('/editarImagem',arguments: [key,item,petId]);
              }else if (key == 'Tipo'){
                mySnackBar('Campo não editável', false);
              }
              else{
                  
                 Get.toNamed('/editarCampo',arguments: [1,key,item,petId]);
              }

            }
            else{
              if(key == 'cnpj' || key == 'Email representante' || key == 'E-mail'){
                mySnackBar('Campo não ainda editável', false);
              }else if(key == 'Endereço'){
                Get.toNamed('/editarEndereco',arguments: [key,item]);

              }
              else{
                Get.toNamed('/editarCampo',arguments: [1,key,item]);
              }
              
            }
            
          },
        ),
    );
      
    rows.add(
      Container(
        width: double.infinity,
        height: (key != 'Endereço' || key != 'Imagem') ? MediaQuery.of(context).size.height * 0.07 : MediaQuery.of(context).size.height * 0.11,
        child: row,
      ),
    );
  });

  return rows;
}


}

// ignore: must_be_immutable
class OngInfoEditPage extends StatelessWidget {
  OngInfoEditPage({super.key});
  var ongInfoEditPageController = Get.put(OngInfoEditPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<OngInfoEditPageController>(
        init: OngInfoEditPageController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: ongInfoEditPageController.func(),
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
                                const Text('Editar',style: TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255)),),
                                const SizedBox(width: 48), // Espaço para alinhar o texto "Publicação" no centro

                              ],
                            ),

                          ),
                          Column(
                            children: ongInfoEditPageController.campoEditar(context)
                          )
                          
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
