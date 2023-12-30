// ignore_for_file: avoid_print, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/ongPages/perfilOng.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

class EditarCampoController extends GetxController {
  //int tipo = Get.arguments[0]; // isso aqui nao serve de nada ainda
  String chave = Get.arguments[1];
  dynamic valor = Get.arguments[2];
  Function? funcaoValidacao;
  var novoValor = TextEditingController();
  RxInt ativado = 0.obs;
  Map<String, dynamic> regrasNegocio = {};
  late SettingsPageController settingsController;
  late String petId;
  late String chaveAux;

  Future<String> func() async {
    settingsController = Get.find(); // Encontra a instância existente

    // verifica de quem chamou essa tela foi para editar um pet.
    if (Get.arguments.length > 3 && Get.arguments[3] != null) {
      petId = Get.arguments[3];
    }

    novoValor.text = valor; // coleta o valor q ja existe
    if (chave == 'Nome' || chave == 'Nome animal' || chave == 'Nome representante') {
      regrasNegocio['maximoCaracteres'] = 40;
      regrasNegocio['texto'] ='Insira o novo valor para $chave. Certifique-se de seguir as regras estabelecidas para este campo';
    } else if (chave == 'Telefone') {
      regrasNegocio['maximoCaracteres'] = 11;
      regrasNegocio['texto'] ='Insira o novo valor para $chave. Certifique-se de digitar apenas numeros com o ddd';
          
    } else if (chave == 'Senha') {
      regrasNegocio['maximoCaracteres'] = 15;
      regrasNegocio['texto'] = 'Insira o novo valor para $chave. Certifique-se de seguir as regras estabelecidas para este campo'; 
    } else if (chave == 'CPF representante') {
      regrasNegocio['maximoCaracteres'] = 11;
      regrasNegocio['texto'] = 'Insira o novo valor para $chave. Certifique-se de seguir as regras estabelecidas para este campo'; 
    }else {
      regrasNegocio['maximoCaracteres'] = 200;
      regrasNegocio['texto'] = 'Insira o novo valor para $chave. Certifique-se de inserir um cpf válido';     
    }
    return 'allan';
  }

  bool validarCPF(String cpfRepresentante) {
    cpfRepresentante = cpfRepresentante.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos      
    if (cpfRepresentante.length != 11) {
      return false;
    }

    if (RegExp(r'^(\d)\1+$').hasMatch(cpfRepresentante)) {
      return false;
    }
    

    // Calcula o primeiro dígito verificador
    int soma = 0;
    for (int i = 0; i < 9; i++) {
      soma += int.parse(cpfRepresentante[i]) * (10 - i);
    }
    int digito1 = (soma * 10) % 11;

    if (digito1 == 10) {
      digito1 = 0;
    }

    if (digito1 != int.parse(cpfRepresentante[9])) {
      return false;
    }

    // Calcula o segundo dígito verificador
    soma = 0;
    for (int i = 0; i < 10; i++) {
      soma += int.parse(cpfRepresentante[i]) * (11 - i);
    }
    int digito2 = (soma * 10) % 11;

    if (digito2 == 10) {
      digito2 = 0;
    }

    return digito2 == int.parse(cpfRepresentante[10]);
  }
  bool validarCEP(String cep) {
    cep = cep.replaceAll(
        RegExp(r'\D'), ''); // Remove caracteres não numéricos do CEP
    // Verifica se o CEP tem 8 dígitos
    if (cep.length != 8) {
      return false;
    }
    return true; // O CEP é válido
  }

  Future<bool> validar() async {
    if (chave == 'Telefone') {
      novoValor.text = novoValor.text.replaceAll(RegExp(r'\D'), ''); // Remove caracteres não numéricos do telefone
      if (novoValor.text.length != 11) {
        return false;
      }
      settingsController.usuario['telefone'] = novoValor.text;
      Get.back();Get.back();
      await MongoDataBase.alteraDocumento('telefone', novoValor.text, settingsController.emailOng);
      return true; // O telefone é válido

    } else if (chave == 'Nome') {
      if (novoValor.text.isNotEmpty) {
        settingsController.nomeOng.value = novoValor.text;
        settingsController.usuario['nomeOng'] = novoValor.text;
        Get.back();Get.back();
        await MongoDataBase.alteraDocumento('nomeOng', novoValor.text, settingsController.emailOng);
        return true;
      }
      return false;
    } else if (chave == 'Senha') {
      if (novoValor.text.isNotEmpty) {
        settingsController.usuario['senha'] = novoValor.text;
        Get.back();Get.back();
        await MongoDataBase.alteraDocumento('password', novoValor.text, settingsController.emailOng);
        return true;
      }
      return false;
    } else if (chave == 'Nome representante') {
      if (novoValor.text.isNotEmpty) {
        settingsController.usuario['nome representante'] = novoValor.text;
        Get.back();Get.back();
        await MongoDataBase.alteraDocumento('nome representante', novoValor.text, settingsController.emailOng);
        return true;
      }
      return false;
    }else if (chave == 'CPF representante') {
      if (validarCPF(novoValor.text)) {
        settingsController.usuario['cpf representante'] = novoValor.text;
        Get.back();Get.back();
        await MongoDataBase.alteraDocumento('cpf representante', novoValor.text, settingsController.emailOng);
        return true;
      }
      mySnackBar('insira um cpf válido!!!\n tente novamente', false);
      return false;
    }else if (chave == 'Nome animal') {
      if (novoValor.text.isNotEmpty) {
        for (int i = 0;
            i < settingsController.usuario['petList'].length;
            i++) {
          if (settingsController.usuario['petList'][i]['id'] == petId) {
            settingsController.usuario['petList'][i]['nome'] = novoValor.text;
            break;
          }
        }
        Get.back();Get.back();Get.back();
        await MongoDataBase.alteraPet('nome', novoValor.text, settingsController.emailOng, petId);
        return true;     
      }
      return false;
    } else {
      print('entrei');
      return false;
    }
  }
}

// ignore: must_be_immutable
class EditarCampoPage extends StatelessWidget {
  EditarCampoPage({Key? key});
  var editarCampoController = Get.put(EditarCampoController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EditarCampoController>(
        init: EditarCampoController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: editarCampoController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(children: [
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
                            Text(editarCampoController.chave,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 255, 255, 255))),
                            const SizedBox(
                                width: 48),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: TextFormField(
                          onChanged: (value) {
                            if (editarCampoController.valor == value) {
                              editarCampoController.ativado.value = 0;
                            } else {
                              editarCampoController.ativado.value = 1;
                            }
                          },
                          maxLength:
                              editarCampoController.regrasNegocio['maximoCaracteres'],
                          controller: editarCampoController.novoValor,
                          decoration: InputDecoration(
                            border: const UnderlineInputBorder(
                                borderSide: BorderSide(width: 0.5, color: Colors.black12)),
                            contentPadding:
                                const EdgeInsets.fromLTRB(8, 0, 8, 0),
                            labelText: editarCampoController.chave,
                            labelStyle: const TextStyle(fontSize: 14),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.clear, size: 18,),
                              onPressed: () {
                                editarCampoController.novoValor.clear();
                              },
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 5, 8.0, 15),
                        child: Text(
                          editarCampoController.regrasNegocio['texto'],
                          style: const TextStyle(fontSize: 16.0, color: Colors.grey),
                        ),
                      ),
                      Obx(
                        () => SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: editarCampoController.ativado.value == 0 ? Colors.black12 :const Color.fromARGB(255, 255, 84, 16)
                            ),
                            onPressed: () {
                              editarCampoController.ativado.value == 0 ? print('botao Desativado') : editarCampoController.validar();
                            },
                            child: const Text('Concluir',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255))),      
                          ),
                        ),
                      ),
                    ],
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
