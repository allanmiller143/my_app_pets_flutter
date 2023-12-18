import 'dart:core';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/usuarioPages/settings_page.dart';

class OngInfoEditPageController extends GetxController {
  late SettingsPageController settingsController;
  dynamic usuario;
  dynamic infoEditavel; 

  Future<String> func() async {
    settingsController = Get.find(); // Encontra a instância existente
    usuario = settingsController.usuario;
    infoEditavel = {
      'nomeOng' : {usuario['nomeOng']},
      'endereco' : {usuario['rua'] , usuario['numero'],  usuario['estado'], usuario['cidade'], usuario['bairro'],usuario['cep']},
      'telefone': {usuario['telefone']},
      'senha': {usuario['senha']},

    };
      

    
    return 'allan';
  }

List<Widget> campoEditar(context, campo) {
  List<Widget> rows = [];

  for (String key in infoEditavel.keys) {
    dynamic  items = infoEditavel[key];
    Widget row;

    if (items.length > 1) {
      // Abre uma tela de edição de vários campos
      row = GestureDetector(
        onTap: () {
          print('Abrir tela de edição de vários campos para $key');
          // Implemente aqui a lógica para abrir a tela de edição de vários campos
        },
        child: Row(
          children: [
            Text('ihuuuu $key (Vários Campos)'),
          ],
        ),
      );
    } else {
      // Abre uma tela de edição simples
      row = GestureDetector(
        onTap: () {
          print('Abrir tela de edição simples para $key');
          // Implemente aqui a lógica para abrir a tela de edição simples
        },
        child: Row(
          children: [ 
            Text('$key (Simples)'),
          ],
        ),
      );
    }

    rows.add(
      Container(
        width: double.infinity,
        height: MediaQuery.of(context).size.height * 0.07,
        child: row,
      ),
    );
  }

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
                            height: MediaQuery.of(context).size.height * 0.09,
                            color: Color.fromARGB(255, 255, 84, 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Adicionado alinhamento
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios,color: Color.fromARGB(255, 255, 255, 255)),                       
                                ),
                                const Text('Editar',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                                const SizedBox(width: 48), // Espaço para alinhar o texto "Publicação" no centro

                              ],
                            ),

                          ),
                          Column(
                            children: ongInfoEditPageController.campoEditar(context, ongInfoEditPageController.infoEditavel)
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
