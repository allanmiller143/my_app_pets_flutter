// ignore: file_names
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/Complete_cep.dart';
import 'package:replica_google_classroom/services/firebase.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class EditarEnderecoController extends GetxController {
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
  late SettingsPageController settingsController;
  late MeuControllerGlobal meuControllerGlobal;
  late String chaveAux;

  Future<void> completarEndereco(cep) async {
    Map<String, dynamic> dados = await buscaCep(cep);
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
    settingsController = Get.find();
    meuControllerGlobal = Get.find();
    // coletar os valores antigos
    rua.text = valores['Rua'];
    numero.text = valores['Numero'];
    cep.text = valores['cep'];
    cidade.text = valores['Cidade'];
    bairro.text = valores['Bairro'];
    estado.text = valores['Estado'];
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
        'Estado' : estado.text,
        'Cidade' : cidade.text,
        'Bairro' : bairro.text,
        'Rua' : rua.text,
        'Numero' : numero.text 
      };
      settingsController.localizacao.value = '${cidade.text}, ${estado.text}';
      settingsController.usuario['cep'] = cep.text;
      settingsController.usuario['Estado'] = estado.text;
      settingsController.usuario['Cidade'] = cidade.text;
      settingsController.usuario['Bairro'] = bairro.text;
      settingsController.usuario['Rua'] = rua.text;
      settingsController.usuario['Numero'] = numero.text;

      meuControllerGlobal.usuario['cep'] = cep.text;
      meuControllerGlobal.usuario['Estado'] = estado.text;
      meuControllerGlobal.usuario['Cidade'] = cidade.text;
      meuControllerGlobal.usuario['Bairro'] = bairro.text;
      meuControllerGlobal.usuario['Rua'] = rua.text;
      meuControllerGlobal.usuario['Numero'] = numero.text;
      
      meuControllerGlobal.estado.value = estado.text;
      meuControllerGlobal.cidade.value = cidade.text;
      meuControllerGlobal.bairro.value = bairro.text;
      meuControllerGlobal.rua.value = rua.text;
      meuControllerGlobal.numero.value = numero.text;
      meuControllerGlobal.cep.value = cep.text;

      Get.back();Get.back();
      await BancoDeDados.adicionarInformacoesUsuario(dados, meuControllerGlobal.obterId());
      mySnackBar('Endereço alterado com sucesso', true);

    }
    else{
      mySnackBar('verifique os campos', false);
    }
  }
  

}

// ignore: must_be_immutable
class EditarEnderecoPage extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
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

