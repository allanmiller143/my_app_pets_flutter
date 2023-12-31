// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously, avoid_print

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../services/mongodb.dart';
import 'dart:math';
import '../services/send_email.dart';
import 'package:replica_google_classroom/widgets/load_widget.dart';

final random = Random();

class SenhaController extends GetxController {
  var senha = TextEditingController();
  dynamic usuario =  Get.arguments[0];
  String email = Get.arguments[0]['email'];
  String nome = Get.arguments[0]['userName'];
  late String cpf;
  dynamic pets;
  

  Future<void> login(BuildContext context) async {
    showLoad(context);
    if (senha.text != '') {
      if (usuario['password'] == senha.text) { 
        if(usuario['Tipo'] != '-1'){
          if(usuario['Tipo'] == '1'){
            pets = await MongoDataBase.retornaListaPets();
            Navigator.of(context).pop();
            
            Get.toNamed('/principalAppPage'); 
          }else{
            Get.toNamed('/principalOngAppPage'); 
          }
        }else{
          pets = await MongoDataBase.retornaListaPets();
          Get.toNamed('/whoAreYouPage',arguments: [nome,email,senha.text]);
          mySnackBar('Conclua seu cadastro!',true);
        }  
      } else {
        Navigator.of(context).pop();
         mySnackBar('Senha incorreta',false);
      }
    } else {
      Navigator.of(context).pop();
      mySnackBar('Preencha todos os campos',false);
    }
  }



  Future<void> forget(BuildContext context) async {
    showLoad(context);
    var codigo = 1000 + random.nextInt(9999 - 1000 + 1);
    await sendEmail(name: nome, email: email,confirmationCode: codigo.toString(),);
    Navigator.of(context).pop();
    mySnackBar('Um código foi enviado ao seu email\nPor favor digite-o abaixo',true);
    Get.toNamed('/confirmPage', arguments: [2, codigo.toString(), nome, email, senha]);  
  }

  void favoritaPet(String petId,bool preferido){
    if(preferido == true){
      print('favoritei');
      usuario['preferedPetsList'].add(petId);
    }else{
      usuario['preferedPetsList'].remove(petId);
    }   
  }

  void atualizaUsuario(Map<String,dynamic> info){
    usuario['data'] = true;
    info.forEach((key, value) { 
      usuario[key] = value;
    });
  }
}

class MyPasswordPage extends StatelessWidget {
  MyPasswordPage({super.key});
  final senhaController = Get.put(SenhaController());
  

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SenhaController>(
        init: SenhaController(),
        builder: (_) {
          return Scaffold(
            // Adicione um Scaffold aqui
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          IconButton(
                            onPressed: () {
                              Get.back();
                            },
                            icon: Icon(
                              Icons.arrow_back_ios,size: 30,weight: 80, color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Log in',
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
                                              senhaController.nome,
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w400,
                                                color: const Color.fromARGB(255, 255, 255, 255), 
                                              ),
                                            ),
                                            Text(
                                              senhaController.email,
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w200,
                                                color: const Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                    TextFormField(
                                      controller: senhaController.senha,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        focusedBorder: OutlineInputBorder(
                                          borderSide: BorderSide(color: Colors.black), // Cor de foco desejada
                                        ),  
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
                                            backgroundColor: Color.fromARGB(255, 236, 71, 6),  
                                            padding:const EdgeInsets.fromLTRB(10, 20, 10, 20),       
                                          ),
                                          child: Text('Continue',
                                            style: TextStyle(fontSize: 20,color: const Color.fromARGB(255, 255, 255, 255)),
                                          ),
                                          onPressed: () async {
                                            await senhaController.login(context);
                                          }),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        senhaController.forget(context);
                                      },
                                      child: Text(
                                        'Esqueceu a senha?',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color:
                                              Color.fromARGB(255, 236, 71, 6),
                                        ),
                                      ),
                                    )
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
