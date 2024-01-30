// ignore_for_file: avoid_print, unrelated_type_equality_checks, use_build_context_synchronously, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:random_string/random_string.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/servicos/banco/firebase.dart';


class SignUpController extends GetxController {
  var nome = TextEditingController();
  var email = TextEditingController();
  var senha = TextEditingController();
  var confirmaSenha = TextEditingController();
  late MeuControllerGlobal meuControllerGlobal;

  validarLogin(context) async {
      if(senha.text.isNotEmpty && senha.text == confirmaSenha.text){
      print('entrei aqui');
      try{
        String id = randomAlphaNumeric(10);
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: senha.text);
        nome.text = nome.text[0].toUpperCase() + nome.text.substring(1);
        String tipo = '-1';
        Map<String,dynamic> userInfoMap = {
          'Nome' : nome.text,
          'E-mail': email.text,
          'Id': id,
          'Pesquisa': nome.text[0],
          'ImagemPerfil': '',
          'Tipo' : tipo,
        };
        
        meuControllerGlobal.usuario = userInfoMap;
        await BancoDeDados.addUsuarioDetalhes(userInfoMap, id);
        
        ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller = ScaffoldMessenger.of(context)
        .showSnackBar(  
          const SnackBar(
            content: Text('Login bem sucedido'),
            backgroundColor: Color.fromARGB(155, 33, 250, 0),
          ),
        );

        await controller.closed;

        Get.toNamed('/whoAreYouPage');
      }on FirebaseAuthException catch(e){
        if(e.code == 'weak-password'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Senha fraca, por favor tente outra mais forte'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        else if(e.code == 'email-already-in-use'){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Esse email já possui conta'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro inesperado'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));

        }
        print(e);
      }
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Insira todos os campos'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
    }
  }

  Future<String> func() async {
    meuControllerGlobal = Get.find();
    return 'a';
  }

}

// ignore: must_be_immutable
class MySignUpPage extends StatelessWidget {
  MySignUpPage({super.key});
  final signUpController = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SignUpController>(
        init: SignUpController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: signUpController.func(),
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
                          padding: const EdgeInsets.fromLTRB(40.0, 10, 40.0, 10),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    icon: const Icon(
                                      Icons.arrow_back_ios,
                                      size: 30,
                                      weight: 80,
                                      color: Color.fromARGB(255, 255, 255, 255),
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 10),
                                    child: Row(
                                      children: [
                                        Text(
                                          'Sign Up',
                                          style: TextStyle(
                                            fontSize: 35,
                                            fontWeight: FontWeight.w600,
                                            color: Color.fromARGB(255, 255, 255, 255),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(5.0),
                                    child: Container(
                                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                      color: const Color.fromRGBO(126, 129, 60, 0.397),
                                      height: 380,
                                      width: 400,
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Vamos criar uma conta? ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold,
                                                color: Color.fromARGB(255, 255, 255, 255),
                                              ),
                                            ),
                                            TextField(
                                              controller: signUpController.nome,
                                              decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                                hintText: "Seu nome",
                                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                              ),
                                            ),
                                            TextField(
                                              controller: signUpController.email,
                                              decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                                hintText: "Email",
                                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                              ),
                                            ),
                                            TextField(
                                              controller: signUpController.senha,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                                hintText: "Senha",
                                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                              ),
                                            ),
                                            TextField(
                                              controller: signUpController.confirmaSenha,
                                              obscureText: true,
                                              decoration: const InputDecoration(
                                                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                                contentPadding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                                                border: OutlineInputBorder(),
                                                filled: true,
                                                hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                                hintText: "Confirma senha",
                                                fillColor: Color.fromARGB(255, 248, 248, 248),
                                              ),
                                            ),
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(10.0),
                                              child: SizedBox(
                                                width: double.infinity,
                                                child: ElevatedButton(
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(255, 236, 71, 6),
                                                    padding: const EdgeInsets.fromLTRB(10, 20, 10, 20),
                                                  ),
                                                  child: const Text("Continuar", style: TextStyle(fontSize: 20, color: Color.fromARGB(255, 255, 255, 255))),
                                                  onPressed: () {
                                                    signUpController.validarLogin(context);
                                                  },
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  } else {
                    return Text('Nenhum dado disponível');
                  }
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar a lista de pets: ${snapshot.error}');
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

