// ignore_for_file: prefer_const_constructors, use_build_context_synchronously

import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignInController extends GetxController {
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

        tipo = "${querySnapshot.docs[0]['Tipo']}";

        if(tipo == '-1'){

           meuControllerGlobal.usuario = {
              'Nome' : querySnapshot.docs[0]['Nome'],
              'Id' : querySnapshot.docs[0]['Id'],
              'E-mail' : querySnapshot.docs[0]['E-mail'],
              'ImagemPerfil' :querySnapshot.docs[0]['ImagemPerfil'],
              'Tipo' : querySnapshot.docs[0]['Tipo'],

           };
           Get.toNamed('/whoAreYouPage');
        }
        else{
          if(tipo == 'ong'){
            var pets = await BancoDeDados.obterPetsDoUsuario(querySnapshot.docs[0]['Id']);
            var imagensFeed =  await BancoDeDados.obterImagensFeedDoUsuario(querySnapshot.docs[0]['Id']);

            meuControllerGlobal.usuario = {
              'Nome' : querySnapshot.docs[0]['Nome'],
              'Id' : querySnapshot.docs[0]['Id'],
              'E-mail' : querySnapshot.docs[0]['E-mail'],
              'Pets' : pets,
              'Tipo' : querySnapshot.docs[0]['Tipo'],
              'Nome ong' : querySnapshot.docs[0]['Nome ong'],
              'cnpj' : querySnapshot.docs[0]['cnpj'],
              'Rua' : querySnapshot.docs[0]['Rua'],
              'Numero' : querySnapshot.docs[0]['Numero'],
              'Estado' : querySnapshot.docs[0]['Estado'],
              'Cidade' : querySnapshot.docs[0]['Cidade'],
              'Bairro' : querySnapshot.docs[0]['Bairro'],
              'cep' : querySnapshot.docs[0]['cep'],
              'Telefone' : querySnapshot.docs[0]['Telefone'],
              'Nome representante' : querySnapshot.docs[0]['Nome representante'],
              'Email representante' : querySnapshot.docs[0]['Email representante'],
              'cpf representante' : querySnapshot.docs[0]['cpf representante'],
              'ImagemPerfil' :querySnapshot.docs[0]['ImagemPerfil'],
              'Bio' : querySnapshot.docs[0]['Bio'],
              'Imagens feed' : imagensFeed
            };  
            Get.toNamed('/principalOngAppPage');  
          }
          else{
            data = querySnapshot.docs[0]['Data'];
            meuControllerGlobal.petsSistema = await BancoDeDados.obterPets();
            print('pets preferidos : ${querySnapshot.docs[0]['Pets preferidos']}');
            if(data == true){
               meuControllerGlobal.usuario = {
                'Id' : querySnapshot.docs[0]['Id'],
                'E-mail' : querySnapshot.docs[0]['E-mail'],
                'Tipo' : querySnapshot.docs[0]['Tipo'],
                'Rua' : querySnapshot.docs[0]['Rua'],
                'Numero' : querySnapshot.docs[0]['Numero'],
                'Estado' : querySnapshot.docs[0]['Estado'],
                'Cidade' : querySnapshot.docs[0]['Cidade'],
                'Bairro' : querySnapshot.docs[0]['Bairro'],
                'cep' : querySnapshot.docs[0]['cep'],
                'Telefone' : querySnapshot.docs[0]['Telefone'],
                'ImagemPerfil' :querySnapshot.docs[0]['ImagemPerfil'],
                'Data': data,
                'Nome completo': querySnapshot.docs[0]['Nome completo'],
                'Pesquisa' : querySnapshot.docs[0]['Pesquisa'],
                'Pets preferidos' : querySnapshot.docs[0]['Pets preferidos'],
                'cpf' : querySnapshot.docs[0]['cpf'],
                'Nome': querySnapshot.docs[0]['Nome'],
               };
            }else{
              meuControllerGlobal.usuario = {
                'Id' : querySnapshot.docs[0]['Id'],
                'E-mail' : querySnapshot.docs[0]['E-mail'],
                'Tipo' : querySnapshot.docs[0]['Tipo'],
                'ImagemPerfil' :querySnapshot.docs[0]['ImagemPerfil'],
                'Data': data,
                'Pesquisa' : querySnapshot.docs[0]['Pesquisa'],
                'Pets preferidos' : querySnapshot.docs[0]['Pets preferidos'],
                'Nome': querySnapshot.docs[0]['Nome'],
               };
            }
            Get.toNamed('/principalAppPage');
            
            }


          }
          ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller = ScaffoldMessenger.of(context)
          .showSnackBar(  
            SnackBar(
              content: Text('Login bem sucedido'),
              backgroundColor: Color.fromARGB(155, 33, 250, 0),
            ),
          );
          await controller.closed;
        }

       on FirebaseException catch(e){
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
    email.text = 'ong@gmail.com';
    senha.text = '32172528';
  
    return 'a';
  }

}

class MyEmailPage extends StatelessWidget {
  MyEmailPage({Key? key}) : super(key: key);

  final signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SignInController>(
        init: SignInController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: signInController.func(),
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
                        
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        TextFormField(
                                          controller: signInController.email,
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
                                          controller: signInController.senha,
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
                                            signInController.login(context);
                                          },
                                          width: double.infinity,
                                          height: 60,
                                          alinhamento: MainAxisAlignment.center,
                                        ),
                                        SizedBox(height: 5),

                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  Get.toNamed('/esqueciSenha');
                                                },
                                                child: Text(
                                                  'Esqueci a senha',
                                                  style: TextStyle(
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold,
                                                    color: const Color.fromARGB(255, 236, 71, 6),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        SizedBox(
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Não possui conta?  ',
                                                style: TextStyle(
                                                  fontSize: 18,
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
