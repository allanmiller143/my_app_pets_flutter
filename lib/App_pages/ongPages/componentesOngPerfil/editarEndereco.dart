// ignore_for_file: avoid_print, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/services/Complete_cep.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class EditarEnderecoController extends GetxController {
  //int tipo = Get.arguments[0]; // isso aqui nao serve de nada ainda
  dynamic chave = Get.arguments[0]; // endereço
  dynamic valores = Get.arguments[1];
  var rua = TextEditingController();
  var numero = TextEditingController();
  var estado = TextEditingController();
  var cidade = TextEditingController();
  var bairro = TextEditingController();

  var ruaAtivado  = false.obs;

  var bairroAtivado  = false.obs;
  var cep = TextEditingController();
  RxInt ativado = 0.obs;
  Map<String, dynamic> regrasNegocio = {};
  late SettingsPageController settingsController;
  late String chaveAux;

  Future<void> completarEndereco(cep) async {
    Map<String, dynamic> dados = await buscaCep(cep);
    print(dados);
    if(dados['bairro'] == ''){
      bairroAtivado.value = true;
    }else{
      bairroAtivado.value = false;
    }
    if(dados['logradouro'] == ''){
      ruaAtivado.value = true;
    }else{
      ruaAtivado.value = false;
    }

    if(dados['uf']== ''){
      mySnackBar('Insira um CEP válido', false);

    }
    
    cidade.text = dados["localidade"];
    estado.text = dados["uf"];
    bairro.text = dados['bairro'];
    rua.text = dados['logradouro'];
  }
  Future<String> func() async {
    settingsController = Get.find(); // Encontra a instância existente
    // coletar os valores antigos
    rua.text = valores['rua'];
    numero.text = valores['numero'];
    cep.text = valores['cep'];
    cidade.text = valores['cidade'];
    bairro.text = valores['bairro'];
    estado.text = valores['estado'];
    return 'allan';
  }
  List<Widget> gerarTextFields() {
    return [
      buildTextField('CEP', cep, 8,true),
      buildTextField('Estado', estado, 2,false),
      buildTextField('Cidade', cidade, 30,false),
      Obx(()=> buildTextField('Bairro', bairro, 30,bairroAtivado.value)),
      Obx(()=> buildTextField('Rua', rua, 30,ruaAtivado.value)),
      buildTextField('Numero', numero, 8,true),
    ];
  }
  Widget buildTextField(String text, TextEditingController controller, int maxLength,bool ativado) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
      child: TextFormField(
        enabled: ativado,
        maxLength: maxLength,
        controller: controller,
        onChanged: (value) async {
          if ( text == 'CEP' && value.length == 8) {
            await completarEndereco(cep.text);
          }
        },
        decoration: InputDecoration(
          border: const UnderlineInputBorder(
            borderSide: BorderSide(width: 0.5, color: Colors.black12),
          ),
          contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
          labelText: text,
          labelStyle: const TextStyle(fontSize: 14),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear, size: 18,),
            onPressed: () {
              controller.clear();
            },
          ),
        ),
      ),
    );
  }
  Future<void> concluirEdicao() async{
    if(cep.text.isNotEmpty && estado.text.isNotEmpty && cidade.text.isNotEmpty && bairro.text.isNotEmpty && rua.text.isNotEmpty && numero.text.isNotEmpty ){
      var dados = {
        'cep' : cep.text,
        'estado' : estado.text,
        'cidade' : cidade.text,
        'bairro' : bairro.text,
        'rua' : rua.text,
        'numero' : numero.text 
      };
      settingsController.localizacao.value = '${cidade.text}, ${estado.text}';
      Get.back();Get.back();
      MongoDataBase.alteraDocumentos(dados, settingsController.emailOng);
    }
    else{
      mySnackBar('verifique os campos', false);
    }
  }
  

}

// ignore: must_be_immutable
class EditarEnderecoPage extends StatelessWidget {
  EditarEnderecoPage({Key? key});
  var editarEnderecoController = Get.put(EditarEnderecoController());

 @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EditarEnderecoController>(
        init: EditarEnderecoController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: editarEnderecoController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.1,
                            color: const Color.fromARGB(255, 255, 84, 16),
                            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  iconSize: 18,
                                  onPressed: () {
                                    Get.back();
                                  },
                                  icon: const Icon(Icons.arrow_back_ios,
                                      color: Color.fromARGB(255, 255, 255, 255)),
                                ),
                                const Text('Endereço',style:  TextStyle(fontSize: 20,color: Color.fromARGB(255, 255, 255, 255))),
                                const SizedBox( width: 48),      
                              ],
                            ),
                          ),
                          Column(
                            children: editarEnderecoController.gerarTextFields()
                          ),
                          Obx(
                            () => SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: editarEnderecoController.ativado.value == 0 ? const Color.fromARGB(255, 255, 84, 16) :const Color.fromARGB(255, 255, 84, 16)
                                ),
                                onPressed: () async {
                                  await editarEnderecoController.concluirEdicao();
                                  
                                },
                                child: const Text('Concluir',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),      
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

