// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/Complete_cep.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import '../widgets/load_widget.dart';
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
  var ruaAtivado  = false.obs;
  var bairroAtivado  = false.obs;
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


List<Widget> gerarTextFields() {
    return [
      buildTextField('Nome ong', nomeOng),
      buildTextField('cnpj', cnpj, maxLength: 14,teclado: 'number'),
      buildTextField('CEP', cep, maxLength: 8,teclado: 'number'),
      buildTextField('Estado', estado,maxLength:  2,ativado: false),
      buildTextField('Cidade', cidade,ativado: false),
      Obx(()=> buildTextField('Bairro', bairro, ativado: bairroAtivado.value)),
      Obx(()=> buildTextField('Rua', rua,ativado: ruaAtivado.value)),
      buildTextField('Numero', numero, maxLength: 3,teclado: 'number'),
      buildTextField('Telefone/com ddd', telefone, maxLength: 11),
      buildTextField('cpf representante', cpfRepresentante, maxLength: 11),
      buildTextField('Email representante', emailRepresentante),
      buildTextField('Nome representante', nomeRepresentante),
    ];
  }


  
Widget buildTextField(String text, TextEditingController controller, {String teclado = 'texto', int maxLength = 1, bool ativado = true, Color backgroundColor = Colors.white}) {
  return Padding(
    padding: maxLength == 1 ? const EdgeInsets.fromLTRB(0, 0, 0, 16) : const EdgeInsets.fromLTRB(0, 0, 0, 0),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text,style: TextStyle(fontWeight: FontWeight.bold),),
        TextFormField(
          onChanged: (value) async {
            if (text == 'CEP' && value.length == 8) {
              await completarEndereco(cep.text);
            }
          },
          keyboardType: teclado == 'texto' ? TextInputType.text : TextInputType.number,
          maxLength: maxLength == 1 ? null : maxLength,
          enabled: ativado,
          controller: controller,
          style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500),
          decoration: InputDecoration(
            filled: true,
            fillColor: backgroundColor, // Define a cor de fundo desejada aqui
            border: const OutlineInputBorder(borderSide: BorderSide(color: Colors.black87)),
            contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
            suffixIcon: IconButton(
              icon: const Icon(Icons.clear, size: 18),
              onPressed: () {
                controller.clear();
              },
            ),
          ),
        ),
      ],
    ),
  );
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
          var usuario = {
              'Pets' : [],
              'Nome ong' : nomeOng.text,
              'cnpj' : cnpj.text,
              'Rua' : rua.text,
              'Numero' : numero.text,
              'Estado' : estado.text,
              'Cidade' : cidade.text,
              'Bairro' : bairro.text,
              'cep' : cep.text,
              'Telefone' : telefone.text,
              'Nome representante' : nomeRepresentante.text,
              'Email representante' : emailRepresentante.text,
              'cpf representante' : cpfRepresentante.text,
              'ImagemPerfil' : '',
              'Bio' : '',
              'Imagens feed' : [],
              'Tipo': 'ong'
            };  
            meuControllerGlobal.usuario.addAll(usuario);
            Get.toNamed('/principalOngAppPage');

          await BancoDeDados.adicionarInformacoesUsuario(usuario, meuControllerGlobal.usuario['Id']);

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
                          child: SingleChildScrollView(
                            child: SizedBox(
                         
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
                                  SizedBox(height: 15,),
                                  
                                  Column(
                                      children: dataOngController.gerarTextFields()
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

