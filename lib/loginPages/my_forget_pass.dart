// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import 'package:replica_google_classroom/widgets/load_widget.dart';
import '../services/mongodb.dart';

class ForgetController extends GetxController {
  String email = Get.arguments[0];
  String nome = Get.arguments[1];
  String senha = '';
  String confirmaSenha = '';

  Future<void> redefinir(BuildContext context) async {
    if (senha != '' && confirmaSenha != "") {
      if (senha == confirmaSenha) {
        showLoad(context);
        await MongoDataBase.trocaSenha(email, senha);
        Navigator.of(context).pop();
        Get.back();
        Get.back();
        mySnackBar('Senha alterada com sucesso!', true);
      } else {
        mySnackBar('As senhas não conferem', false);
      }
    }else{
      mySnackBar('Preencha Todos os campos', false);
    }
    
  }

  void resetar() {
    email = '';
    senha = '';
    confirmaSenha = '';
    nome = '';
  }
}

class MyForgetPage extends StatelessWidget {
  MyForgetPage({super.key});

  final forgetController = Get.put(ForgetController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<ForgetController>(
        init: ForgetController(),
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
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Redefinir senha',
                                  style: TextStyle(
                                    fontSize: 35,
                                    fontWeight: FontWeight.w600,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5.0),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              color: Color.fromRGBO(126, 129, 60, 0.397),
                              height: 320,
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                child: Column(
                                  mainAxisAlignment:MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                          child: ClipOval(
                                            child: Image.asset(
                                              'assets/fundo.png',
                                              width: 60,
                                              height: 60,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:CrossAxisAlignment.start,    
                                          mainAxisAlignment:MainAxisAlignment.end,    
                                          children: [
                                            Text(
                                              forgetController.nome,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                            ),
                                            Text(
                                              forgetController.email,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200,
                                                color: const Color.fromARGB(255, 255, 255, 255),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    TextField(
                                      onChanged: (text) {
                                        forgetController.senha = text;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),
                                        contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintStyle: TextStyle(
                                          color: Color.fromARGB(255, 0, 0, 0),
                                        ),
                                        hintText: "Nova senha",
                                        fillColor:Color.fromARGB(255, 248, 248, 248),
                                      ),
                                    ),
                                    TextField(
                                      onChanged: (text) {
                                        forgetController.confirmaSenha = text;
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black),),  
                                        contentPadding:EdgeInsets.fromLTRB(10, 10, 10, 10),     
                                        border: OutlineInputBorder(),
                                        filled: true,
                                        hintStyle: TextStyle(color: Color.fromARGB(255, 0, 0, 0),),
                                        hintText: "Confirmar nova senha",
                                        fillColor: Color.fromARGB(255, 248, 248, 248),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10.0),
                                      child: SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromARGB(255, 236, 71, 6),
                                            padding:const EdgeInsets.fromLTRB(10, 20, 10, 20),      
                                          ),
                                          child: Text("Confirmar",style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 255, 255, 255)),
                                          ),
                                          onPressed: () async {
                                            await forgetController.redefinir(context);    
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
