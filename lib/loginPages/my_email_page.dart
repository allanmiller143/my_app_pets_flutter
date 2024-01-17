// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/firebase.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmailController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;  
  
  dynamic usuario;
  var email = TextEditingController();
  var senha = TextEditingController();
  String nome = '';
  String id = '';
  String tipo = '';
  String imagemPerfil = '';
  bool data = false;
  var petsPreferidos = [];

login(context) async{
    if(email.text.isNotEmpty || senha.text.isNotEmpty){
      try{
        await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: senha.text);
        QuerySnapshot querySnapshot = await BancoDeDados.getUsuarioPorEmail(email.text);
        
        // informações das duas contas

        nome = "${querySnapshot.docs[0]['Nome']}";
        id = "${querySnapshot.docs[0]['Id']}";
        tipo = "${querySnapshot.docs[0]['Tipo']}";
        imagemPerfil = "${querySnapshot.docs[0]['ImagemPerfil']}";
        meuControllerGlobal.salvarEmail(email.text);
        meuControllerGlobal.salvarId(id);
        meuControllerGlobal.salvarNome(nome);
        meuControllerGlobal.salvarImagemPerfil(imagemPerfil);
        meuControllerGlobal.salvarTipo(tipo);


        ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller = ScaffoldMessenger.of(context)
        .showSnackBar(  
          SnackBar(
            content: Text('Login bem sucedido'),
            backgroundColor: Color.fromARGB(155, 33, 250, 0),
          ),
        );
        await controller.closed;
       

        if(tipo == '-1'){
          Get.toNamed('/whoAreYouPage');
        }
        else{
          if(tipo == 'comum'){ 
            data = querySnapshot.docs[0]['Data'];
            petsPreferidos = querySnapshot.docs[0]['Pets preferidos']; 
            meuControllerGlobal.petsPreferidos = petsPreferidos;
            meuControllerGlobal.salvarData(data);
            if(data == true){
              String bairro = querySnapshot.docs[0]['Bairro'];
              String cidade = querySnapshot.docs[0]['Cidade'];
              String estado = querySnapshot.docs[0]['Estado'];
              String numero = querySnapshot.docs[0]['Numero'];
              String rua = querySnapshot.docs[0]['Rua'];
              String telefone = querySnapshot.docs[0]['Telefone'];
              String cep = querySnapshot.docs[0]['cep'];
              meuControllerGlobal.bairro.value = bairro;
              meuControllerGlobal.cidade.value = cidade;
              meuControllerGlobal.numero.value = numero;
              meuControllerGlobal.rua.value = rua;
              meuControllerGlobal.telefone.value = telefone;
              meuControllerGlobal.cep.value = cep;
              meuControllerGlobal.estado.value = estado;

              
            }
          }else{ //ong 
            String bairro = querySnapshot.docs[0]['Bairro'];
            String cidade = querySnapshot.docs[0]['Cidade'];
            String emailRepresentante = querySnapshot.docs[0]['Email representante'];
            String estado = querySnapshot.docs[0]['Estado'];
            var imagensFeed = querySnapshot.docs[0]['Imagens feed'];
            var pets = querySnapshot.docs[0]['Pets'];
            String nomeOng = querySnapshot.docs[0]['Nome ong'];
            String nomeRepresentante= querySnapshot.docs[0]['Nome representante'];
            String numero = querySnapshot.docs[0]['Numero'];
            String rua = querySnapshot.docs[0]['Rua'];
            String telefone = querySnapshot.docs[0]['Telefone'];
            String cep = querySnapshot.docs[0]['cep'];
            String cnpj = querySnapshot.docs[0]['cnpj'];
            String cpfRepresentante = querySnapshot.docs[0]['cpf representante'];

            meuControllerGlobal.bairro.value = bairro;
            meuControllerGlobal.cidade.value = cidade;
            meuControllerGlobal.emailRepresentante.value = emailRepresentante;
            meuControllerGlobal.imagensFeed = imagensFeed;
            meuControllerGlobal.estado.value = estado;
            meuControllerGlobal.pets = pets;
            meuControllerGlobal.nomeRepresentante.value = nomeRepresentante;
            meuControllerGlobal.nomeOng.value = nomeOng;
            meuControllerGlobal.numero.value = numero;
            meuControllerGlobal.rua.value = rua;
            meuControllerGlobal.telefone.value = telefone;
            meuControllerGlobal.cep.value = cep;
            meuControllerGlobal.cnpj.value = cnpj;
            meuControllerGlobal.cpfRepresentante.value = cpfRepresentante;

            meuControllerGlobal.criaUsuario();
            Get.toNamed('/principalOngAppPage');

          }

        }
      } on FirebaseException catch(e){
        if(e.code == 'invalid-credential'){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('E-mail ou senha incorreta'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        else if(e.code == 'wrong-password'){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Senha incorreta'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro inesperado, tente novamente mais tarde'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        print(e);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Insira Email e senha'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));

    }
    
  }

  Future<String> func() async {
    meuControllerGlobal = Get.find();
    email.text = 'ong.pets@gmail.com';
    senha.text = '32172528';
  
    return 'a';
  }

}

class MyEmailPage extends StatelessWidget {
  MyEmailPage({Key? key}) : super(key: key);

  final emailController = Get.put(EmailController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EmailController>(
        init: EmailController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: emailController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Stack(
                      children: [
                        Image.asset(
                          "assets/fundo.png",
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(40.0, 10, 40.0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Olá !",
                                    style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w800,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20.0),
                                child: Container(
                                  color: Color.fromRGBO(126, 129, 60, 0.397),
                                  padding: EdgeInsets.fromLTRB(10, 10, 10, 5),
                                  width: 400,
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFormField(
                                          controller: emailController.email,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            hintText: "Email",
                                            fillColor: Color.fromARGB(255, 248, 248, 248),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        TextFormField(
                                          controller: emailController.senha,
                                          obscureText: true,
                                          decoration: InputDecoration(
                                            focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(color: Colors.black),
                                            ),
                                            contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                            border: OutlineInputBorder(),
                                            filled: true,
                                            hintStyle: TextStyle(
                                              color: Color.fromARGB(255, 0, 0, 0),
                                            ),
                                            hintText: "Senha",
                                            fillColor: Color.fromARGB(255, 248, 248, 248),
                                          ),
                                        ),
                                        SizedBox(height: 15),
                                        CustomIconButton(
                                          label: 'Entrar',
                                          onPressed: () {
                                            emailController.login(context);
                                          },
                                          width: double.infinity,
                                          height: 60,
                                          alinhamento: MainAxisAlignment.center,
                                        ),
                                        SizedBox(height: 5),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Não possui conta?  ',
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Get.toNamed('/signUp');
                                              },
                                              child: Text(
                                                'Cadastre-se',
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                  color: const Color.fromARGB(255, 236, 71, 6),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  
                  } else {
                    return Text('erro');
                  }
                } else {
                  return Center(child: CircularProgressIndicator(color: Color.fromARGB(255, 253, 72, 0),));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
