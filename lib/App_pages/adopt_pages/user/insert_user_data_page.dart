
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/App_pages/adopt_pages/user/validar.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/Complete_cep.dart';
import 'package:replica_google_classroom/services/mongodb.dart';
import 'package:replica_google_classroom/widgets/load_Widget.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';

class InsertUserDataPageController extends GetxController {
  String titulo = Get.arguments[0];
  String subtitulo = Get.arguments[1];
  late SenhaController senhaController;
  
  var cpf = TextEditingController();
  var rua = TextEditingController();
  var numero = TextEditingController();
  var estado = TextEditingController();
  var cidade = TextEditingController();
  var bairro = TextEditingController();
  var telefone = TextEditingController();
  var ruaAtivado  = false.obs;
  var bairroAtivado  = false.obs;
  var cep = TextEditingController();
  var nome = TextEditingController();

  Future<String> func() async {
    
    return 'allan';
  } 

   @override
  void onInit() {
    // verificar se o usuario ja possui dados cadastrados no sistema, se sim, essa tela vai ser de alteração, se nap se inserção
    senhaController = Get.find();

    if(senhaController.usuario['data'] == true) {
      nome.text = senhaController.usuario['nome completo'];
      cep.text = senhaController.usuario['cep'];
      estado.text = senhaController.usuario['estado'];
      cidade.text = senhaController.usuario['cidade'];
      bairro.text = senhaController.usuario['bairro'];
      rua.text = senhaController.usuario['rua'];
      telefone.text = senhaController.usuario['telefone'];
      cpf.text = senhaController.usuario['cpf'];
      numero.text = senhaController.usuario['numero'];
    }
    super.onInit();
  } 
  

  // faz a consulta na api, e completa os campos automaticamente
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
    telefone.text = dados['ddd'];
  }

List<Widget> gerarTextFields() {
    return [
      buildTextField('Nome completo', nome),
      buildTextField('CEP', cep, maxLength: 8,teclado: 'number'),
      buildTextField('Estado', estado,maxLength:  2,ativado: false),
      buildTextField('Cidade', cidade,ativado: false),
      Obx(()=> buildTextField('Bairro', bairro, ativado: bairroAtivado.value)),
      Obx(()=> buildTextField('Rua', rua,ativado: ruaAtivado.value)),
      buildTextField('Telefone/com ddd', telefone, maxLength: 11),
      buildTextField('CPF', cpf, maxLength: 11),
      buildTextField('Numero', numero,teclado: 'number'),
    ];
  }


  
  Widget buildTextField(String text, TextEditingController controller, {String teclado = 'texto' ,int maxLength = 1, bool ativado = true}) {
    return Padding(
      padding: maxLength == 1?  const EdgeInsets.fromLTRB(0,0,0,16) :const EdgeInsets.fromLTRB(0,0,0,0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(text),
            TextFormField(
              onChanged: (value) async {
                if (text == 'CEP' && value.length == 8) {
                  await completarEndereco(cep.text);
                }
              },
              keyboardType: teclado == 'texto' ? TextInputType.text : TextInputType.number,
              maxLength: maxLength == 1 ? null :maxLength,
              enabled: ativado,
              controller: controller,
              decoration: InputDecoration(
                border: const OutlineInputBorder(borderSide: BorderSide()),
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

  void validarCampos() async{
    if(nome.text.isEmpty ||cpf.text.isEmpty || rua.text.isEmpty || numero.text.isEmpty || estado.text.isEmpty || cidade.text.isEmpty || bairro.text.isEmpty ||telefone.text.isEmpty){
      mySnackBar('preencha todos os campos', false);
    }else{
      String mensagemRetorno = 'Campos ínvalidos:\n';
      if(!validarCPF(cpf.text)){ // aqui verificar se o cpf ja consta no sistema.
        mensagemRetorno = '${mensagemRetorno}cpf\n';
      }
      if(!validarTelefone(telefone.text)){
        mensagemRetorno = '${mensagemRetorno}telefone\n';
      }
      if(!validarCEP(cep.text)){
        mensagemRetorno = '${mensagemRetorno}CEP\n';
      }

      if(mensagemRetorno == 'Campos ínvalidos:\n'){
        
        Map<String,dynamic> info = {
          'nome completo': nome.text,
          'cep': cep.text,
          'estado': estado.text,
          'cidade': cidade.text,
          'bairro': bairro.text,
          'rua' : rua.text,
          'numero': numero.text,
          'telefone': telefone.text,
          'cpf': cpf.text       
        };
        mySnackBar('cadastro realizado com sucesso!', true);
        senhaController.atualizaUsuario(info);
        await MongoDataBase.insertUserData(senhaController.email, info);
        Get.toNamed('/userDataPage');
        
      }else {
        mySnackBar(mensagemRetorno, false);
      }
      
    }

  }






 
}
// ignore: must_be_immutable
class InsertUserDataPage extends StatelessWidget {
  InsertUserDataPage({super.key});

  var insertUserDataPageController = Get.put(InsertUserDataPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.1,
          backgroundColor: const Color.fromARGB(255, 250, 63, 6),
          centerTitle: true,
          title: Text (
            insertUserDataPageController.titulo,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Color.fromARGB(255, 255, 255, 255)),
          ),
          leading: IconButton (
            icon: const Icon(Icons.arrow_back_ios, color: Color.fromARGB(255, 255, 255, 255)),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SingleChildScrollView (
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding:const  EdgeInsets.fromLTRB(0,0,0,15),
                  child: Text(insertUserDataPageController.subtitulo,
                  style:const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
                ),
                Column(
                  children: insertUserDataPageController.gerarTextFields()
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
                    child: CustomIconButton(
                      label: 'Confirmar',
                      onPressed: () {
                        insertUserDataPageController.validarCampos();
                      },
                      width: 250,
                      alinhamento: MainAxisAlignment.center,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
