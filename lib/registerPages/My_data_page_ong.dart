// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../widgets/load_widget.dart';
import '../widgets/my_textformfield.dart';
import '../widgets/mybutton.dart';
import '../entitites/Ong.dart';
import '../services/mongodb.dart';
import '../services/Complete_cep.dart';

class DataOngController extends GetxController {
  static DataOngController get to => Get.find();

  // Variáveis para armazenar os dados do usuário
  var nomeOng = TextEditingController();
  var cnpj = TextEditingController();
  var rua = TextEditingController();
  var numero = TextEditingController();
  var estado = TextEditingController();
  var cidade = TextEditingController();
  var bairro = TextEditingController();
  var cep = TextEditingController();
  var telefone = TextEditingController();
  var nomeRepresentante = TextEditingController();
  var cpfRepresentante = TextEditingController();
  var emailRepresentante = TextEditingController();
  List<TextEditingController> controllers = [];


Future<void> completarEndereco(cep) async {
    Map<String, dynamic> dados = await buscaCep(cep);
    cidade.text = dados["localidade"];
    estado.text = dados["uf"];
    telefone.text = dados['ddd'];
    bairro.text = dados['bairro'];
    rua.text = dados['logradouro'];
  }

  Future<void> fazerCadastro(BuildContext context) async {
    String email = Get.arguments[1]; // pegar o email que vou receber da outra tela.
    showLoad(context);
    var ong = Ong(
      nomeOng: nomeOng.text,
      cnpj: cnpj.text,
      rua: rua.text,
      numero: numero.text,
      estado: estado.text,
      cidade: cidade.text,
      bairro: bairro.text,
      cep: cep.text,
      telefone: telefone.text,
      nomeRepresentante: nomeRepresentante.text,
      emailRepresentante: emailRepresentante.text,
      cpfRepresentante: cpfRepresentante.text,
    );

    Map<String, String> ongDataMap = ong.toMap();
    
    String retorno = 'Por Favor, Preencha essas campos:\n';
    bool faltaCampo = false;

    ongDataMap.forEach((campo, valor) {
      if (valor.isEmpty) {
        faltaCampo = true;
        retorno += '$campo\n';
      }
    });

    if (faltaCampo == false) {
      retorno = ong.validaCampos(cpfRepresentante.text,cnpj.text, cep.text, telefone.text);
      if (retorno == '') {
        await MongoDataBase.insertUserData(email, ongDataMap);
        Navigator.of(context).pop();
        mySnackBar('Cadastro bem sucedido',true);
      }
      else{
        Navigator.of(context).pop();
        mySnackBar(retorno,false);
      }
    }else{
      Navigator.of(context).pop();
      mySnackBar(retorno,false);
    }
    
  }

  // Função para resetar todos os campos
  void reset() {}
}

class MyOngDataPage extends StatelessWidget {
  MyOngDataPage({Key? key}) : super(key: key);

  final dataOngController = Get.put(DataOngController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<DataOngController>(
        init: DataOngController(),
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
                                dataOngController.reset();
                                Get.back();
                              },
                              icon: Icon(
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
                              hintText: 'Nome ONG',
                              controller: dataOngController.nomeOng,
                              width: 190,
                            ),
                            CustomTextFormField(
                              hintText: 'CNPJ',
                              controller: dataOngController.cnpj,
                              width: 150,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'CEP sede',
                              controller: dataOngController.cep,
                              width: 95,
                              keyboardType: TextInputType.number,
                            ),
                            CustomTextFormField(
                              hintText: 'Bairro sede',
                              controller: dataOngController.bairro,
                              width: 130,
                              onChanged: (value) async {
                                if (value.length == 8) {
                                  await dataOngController.completarEndereco(value);
                                }
                              },
                            ),
                            CustomTextFormField(
                              hintText: 'Telefone sede',
                              controller: dataOngController.telefone,
                              width: 115,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Rua sede',
                              controller: dataOngController.rua,
                              width: 280,
                            ),
                            CustomTextFormField(
                              hintText: 'n°',
                              controller: dataOngController.numero,
                              width: 60,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Estado sede',
                              controller: dataOngController.estado,
                              width: 60,
                            ),
                            CustomTextFormField(
                              hintText: 'Cidade sede',
                              controller: dataOngController.cidade,
                              width: 230,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomTextFormField(
                              hintText: 'Nome representante',
                              controller: dataOngController.nomeRepresentante,
                              width: 210,
                            ),
                            CustomTextFormField(
                              hintText: 'cpf representante',
                              controller: dataOngController.cpfRepresentante,
                              width: 140,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CustomTextFormField(
                              hintText: 'email representante',
                              controller: dataOngController.emailRepresentante,
                              width: 250,
                            ),
                          ],
                        ),
                        CustomIconButton(
                            label: 'Confirmar',
                            onPressed: () async {
                              await dataOngController.fazerCadastro(context);  
                            },
                            width: double.infinity,
                            alinhamento: MainAxisAlignment.center),
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
