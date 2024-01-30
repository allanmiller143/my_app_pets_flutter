// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/Complete_cep.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import '../widgets/load_widget.dart';
import '../widgets/my_textformfield.dart';
import '../widgets/mybutton.dart';
import '../entitites/Ong.dart';


class DataOngController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;  

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


  Future<String> func() async {
    meuControllerGlobal = Get.find();
    return 'a';
  }

  Future<void> completarEndereco(cep) async {
    Map<String, dynamic> dados = await buscaCep(cep);
    cidade.text = dados["localidade"];
    estado.text = dados["uf"];
    telefone.text = dados['ddd'];
    bairro.text = dados['bairro'];
    rua.text = dados['logradouro'];
  }

  Future<void> fazerCadastro(BuildContext context) async {
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

    Map<String, dynamic> ongDataMap = ong.toMap();
    
    String retorno = 'Por Favor, Preencha essas campos:\n';
    bool faltaCampo = false;

    ongDataMap.forEach((campo, valor) {
      if (valor.isEmpty) {
        faltaCampo = true;
        retorno += '$campo\n';
      }
    });

    if (faltaCampo == false) {
      retorno = await ong.validaCampos(cpfRepresentante.text,cnpj.text, cep.text, telefone.text);
      if (retorno == '') {
          
          meuControllerGlobal.nomeOng.value = ongDataMap['Nome ong']!;
          meuControllerGlobal.cnpj.value = ongDataMap['cnpj']!;
          meuControllerGlobal.cep.value = ongDataMap['cep']!;
          meuControllerGlobal.numero.value = ongDataMap['Numero']!;
          meuControllerGlobal.bairro.value = ongDataMap['Bairro']!;
          meuControllerGlobal.telefone.value = ongDataMap['Telefone']!;
          meuControllerGlobal.rua.value = ongDataMap['Rua']!;
          meuControllerGlobal.numero.value = ongDataMap['Numero']!;
          meuControllerGlobal.estado.value = ongDataMap['Estado']!;
          meuControllerGlobal.cidade.value = ongDataMap['Cidade']!;
          meuControllerGlobal.nomeRepresentante.value = ongDataMap['Nome representante']!;
          meuControllerGlobal.emailRepresentante.value = ongDataMap['Email representante']!;
          meuControllerGlobal.cpfRepresentante.value = ongDataMap['cpf representante']!;
          meuControllerGlobal.tipo.value = 'ong';
          ongDataMap['Pets'] = [];
          ongDataMap['Imagens feed'] = [];
          ongDataMap['Bio'] = '';

          await BancoDeDados.adicionarInformacoesUsuario(ongDataMap, meuControllerGlobal.obterId());
          await meuControllerGlobal.criaUsuarioSignUp();
  
          mySnackBar('Cadastro bem sucedido',true);
          Get.toNamed('/principalOngAppPage');
      }
      else{
        mySnackBar(retorno,false);
      }
    }else{
      mySnackBar(retorno,false);
    }
    
  }


}
class MyOngDataPage extends StatelessWidget {
  MyOngDataPage({super.key});

  final dataOngController = Get.put(DataOngController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<DataOngController>(
        init: DataOngController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: dataOngController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        Image.asset(
                          "assets/dataPagebackground.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: SizedBox(
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
                                      onChanged: (value) async {
                                        if (value.length == 8) {
                                          await dataOngController.completarEndereco(value);
                                        }
                                      },
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
                                      width: 90,
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
                                  onPressed: ()  {
                                    dataOngController.fazerCadastro(context);
                                  },
                                  width: double.infinity,
                                  alinhamento: MainAxisAlignment.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    return const Text('erro');
                  }
                } else {
                  return const Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0),));
                }
              },
            ),
          );
        },
      ),
    );
  }
}

