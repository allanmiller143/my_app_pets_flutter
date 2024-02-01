// ignore_for_file: unnecessary_string_interpolations, avoid_print, unnecessary_brace_in_string_interps

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
          trailing: const Icon(Icons.arrow_drop_down),
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
      SizedBox(
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
            appBar: AppBar(
              toolbarHeight: MediaQuery.of(context).size.height * 0.1,
              backgroundColor: const Color.fromARGB(255, 250, 63, 6),
              centerTitle: true,
              title: const Text(
                'Editar',
                style: TextStyle(fontSize: 20,fontFamily: 'AsapCondensed-Medium', fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
              ),
              leading: IconButton(onPressed: () => Get.back(), icon: const Icon(Icons.arrow_back_ios_new,size: 18, color: Color.fromARGB(255, 255, 255, 255))),  
              
            ),
            body: FutureBuilder(
              future: ongInfoEditPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        children: [
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
