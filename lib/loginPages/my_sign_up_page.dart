// ignore_for_file: avoid_print, unrelated_type_equality_checks, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import '../services/mongodb.dart';
import 'dart:math';
import 'package:replica_google_classroom/widgets/load_widget.dart';
import '../services/send_email.dart';

final random = Random();

class Controller extends GetxController {
  static Controller get to => Get.find(); // serve para acessar a variável de forma mais simples
  String nome = '';
  String email = '';
  String senha = '';




  Future<void> validarLogin(BuildContext context) async {
    showLoad(context);

    if (email != '' && senha != '' && nome != '') {





      if (await MongoDataBase.verificaUser(email)) {
        Navigator.of(context).pop();
        mySnackBar('Usuário já possui cadastro!',false);
      } else {
      
        var codigo = 1000 + random.nextInt(9999 - 1000 + 1);
        
        await sendEmail(name: nome.toString(),email: email.toString(),confirmationCode: codigo.toString(),);
        Navigator.of(context).pop(); // fecha o showLoad
        Get.toNamed('/confirmPage',arguments: [1, codigo.toString(), nome, email, senha]);
          mySnackBar('Um código foi enviado ao seu email\nPor favor digite-o abaixo',true);  
            
      }
    } else {
      Navigator.of(context).pop();
      mySnackBar('Preencha todos os campos',false);
    }
  }

  void resetar() {
    nome = '';
    email = '';
    senha = '';
  }
}

// ignore: must_be_immutable
class MySignUpPage extends StatelessWidget {
  MySignUpPage({super.key});
  final controller = Get.put(Controller());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<Controller>(
        init: Controller(),
        builder: (_) {
          return Scaffold(
            body: Stack(
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
                              controller.resetar();
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
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    const Text(
                                      'Parece que você ainda não possui uma conta cadastrada.\nVamos criar uma? ',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                        color:Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (text) {
                                        controller.nome = text;
                                        print(controller.nome);
                                      },
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                        contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                        hintText: "Seu nome",
                                        fillColor:Color.fromARGB(255, 248, 248, 248), 
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (text) {controller.email = text;},
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                        contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                        hintText: "Email",
                                        fillColor:Color.fromARGB(255, 248, 248, 248),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (text) {controller.senha = text;},
                                      obscureText: true,
                                      decoration: const InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                        contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                        hintText: "Senha",
                                        fillColor:Color.fromARGB(255, 248, 248, 248),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:const Color.fromARGB(255, 236, 71, 6),
                                            padding:const EdgeInsets.fromLTRB(10, 20, 10, 20),  
                                          ),
                                          child: const Text("Continuar",style: TextStyle(fontSize: 20,color:  Color.fromARGB(255, 255, 255, 255)),
                                          ),
                                          onPressed: () async {               
                                            await controller.validarLogin(context);
                                          }
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
            ),
          );
        },
      ),
    );
  }
}
