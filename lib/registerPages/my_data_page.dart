// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';
import 'package:replica_google_classroom/widgets/my_textformfield.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:replica_google_classroom/entitites/user.dart';
import '../services/mongodb.dart';
import '../services/Complete_cep.dart';


class DataController extends GetxController {
  static DataController get to => Get.find();

  // Variáveis para armazenar os dados do usuário
  var primeiroNome = TextEditingController();
  var sobrenome = TextEditingController();
  var rua = TextEditingController();
  var numero = TextEditingController();
  var estado = TextEditingController();
  var cidade = TextEditingController();
  var bairro = TextEditingController();
  var cep = TextEditingController();
  var telefone = TextEditingController();
  var dataNascimento = TextEditingController();
  var cpf = TextEditingController();

  Future<void> completarEndereco(cep) async {
    Map<String, dynamic> dados = await buscaCep(cep);
    cidade.text = dados["localidade"];
    estado.text = dados["uf"];
    telefone.text = dados['ddd'];
    bairro.text = dados['bairro'];
    rua.text = dados['logradouro'];
  }

  Future<void> fazerCadastro(BuildContext context) async {
    String email =
        Get.arguments[1]; // pegar o email que vou receber da outra tela.
    showLoad(context);

    var usuario = Usuario(
      primeiroNome: primeiroNome.text,
      sobrenome: sobrenome.text,
      rua: rua.text,
      numero: numero.text,
      estado: estado.text,
      cidade: cidade.text,
      bairro: bairro.text,
      cep: cep.text,
      telefone: telefone.text,
      dataNascimento: dataNascimento.text,
      cpf: cpf.text,
    );

    Map<String, String> userDataMap = usuario.toMap();

    String retorno = 'Por Favor, Preencha todos os campos:\n';
    bool faltaCampo = false;

    userDataMap.forEach((campo, valor) {
      if (valor.isEmpty) {
        faltaCampo = true;
        retorno += '$campo\n';
      }
    });

    if (faltaCampo == false) {
      retorno = usuario.validaCampos(cpf.text, cep.text, telefone.text);
      if (retorno == '') {
        await MongoDataBase.insertUserData(email, userDataMap);
        Navigator.of(context).pop();
        mySnackBar('Cadastro bem sucedido', true);
      } else {
        Navigator.of(context).pop();
        mySnackBar(retorno, false);
      }
    } else {
      Navigator.of(context).pop();
      mySnackBar(retorno, false);
    }
  }

  Future<void> selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      // Formate a data selecionada como "dd/mm/aaaa"
      String formattedDate =
          "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      dataNascimento.text = formattedDate;
    }
  }
}

class MyDataPage extends StatelessWidget {
  MyDataPage({Key? key}) : super(key: key);

  final dataController = Get.put(DataController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<DataController>(
        init: DataController(),
        builder: (_) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/dataPagebackground.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    height: 600,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              onPressed: () {
                                Get.back();
                              },
                              icon: const Icon(
                                Icons.arrow_back_ios,
                                size: 30,
                                weight: 80,
                              ),
                            ),
                          ],
                        ),
                        Image.asset(
                          'assets/minhaLogo.png',
                          width: 250,
                          height: 50,
                        ),
                        const Text(
                          "Complete seu cadastro!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Primeiro Nome',
                              controller: dataController.primeiroNome,
                              width: 130,
                            ),
                            CustomTextFormField(
                              hintText: 'Sobrenome',
                              controller: dataController.sobrenome,
                              width: 210,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GestureDetector(
                              onTap: () {
                                dataController.selectDate(context);
                              },
                              child: CustomTextFormField(
                                hintText: 'Data nascimento',
                                controller: dataController.dataNascimento,
                                width: 150,
                                enabled: false,
                              ),
                            ),
                            CustomTextFormField(
                              hintText: 'Cpf',
                              controller: dataController.cpf,
                              width: 185,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Este campo é obrigatório.';
                                }
                                return null; // Retorna null se o valor for válido
                              },
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'CEP',
                              controller: dataController.cep,
                              width: 95,
                              onChanged: (value) async {
                                if (value.length == 8) {
                                  await dataController.completarEndereco(value);
                                }
                              },
                            ),
                            CustomTextFormField(
                              hintText: 'Bairro',
                              controller: dataController.bairro,
                              width: 130,
                            ),
                            CustomTextFormField(
                              hintText: 'Telefone',
                              controller: dataController.telefone,
                              width: 115,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Rua',
                              controller: dataController.rua,
                              width: 280,
                            ),
                            CustomTextFormField(
                              hintText: 'n°',
                              controller: dataController.numero,
                              width: 60,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Estado',
                              controller: dataController.estado,
                              width: 60,
                            ),
                            CustomTextFormField(
                              hintText: 'Cidade',
                              controller: dataController.cidade,
                              width: 290,
                            ),
                          ],
                        ),
                        CustomIconButton(
                          label: 'Confirmar',
                          onPressed: () async {
                            await dataController.fazerCadastro(context);
                          },
                          width: double.infinity,
                          alinhamento: MainAxisAlignment.center,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
