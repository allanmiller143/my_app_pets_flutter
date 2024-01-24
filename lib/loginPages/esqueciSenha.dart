// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, avoid_unnecessary_containers, avoid_print, unnecessary_import, unused_import
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';

class EsqueciSenhaController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  var email = TextEditingController();

  esqueciSenha(context) async{
    if(email.text.isNotEmpty ){
      try{
        await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
        ScaffoldFeatureController<SnackBar, SnackBarClosedReason> controller = ScaffoldMessenger.of(context)
        .showSnackBar(  
          SnackBar(
            content: Text('Um email para recuperar senha foi enviado'),
            backgroundColor: Color.fromARGB(155, 33, 250, 0),
          ),
        );
        await controller.closed;
        email.clear();

        Get.toNamed('/');
      } on FirebaseException catch(e){
        if(e.code == "user-not-found"){
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Usuario não encontrado, tente novamente!'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Ocorreu um erro inesperado, tente novamente mais tarde'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));
        }
        print(e);
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Insira seu Email'),backgroundColor: Color.fromARGB(155, 250, 0, 0),));

    }
    
  }

  Future<String> func() async {
    meuControllerGlobal = Get.find();
    return 'a';
  }
}

class EsqueciSenhaPage extends StatelessWidget {
  EsqueciSenhaPage({super.key});
  var esqueciSenhaController = Get.put(EsqueciSenhaController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<EsqueciSenhaController>(
        init: EsqueciSenhaController(),
        builder: (_) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              toolbarHeight: 100,
              forceMaterialTransparency: true,
              leading: IconButton(onPressed: (){Get.back();}, icon: Icon(Icons.arrow_back_ios,color: Color.fromARGB(255, 255, 255, 255),)),
            ),
            body:FutureBuilder(
            future: esqueciSenhaController.func(),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  return 
                   Stack(
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
                                        'Recupere sua senha',
                                        style: TextStyle(
                                          fontSize: 20,
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
                          
                                    child: BackdropFilter(
                                      filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                                      child: Column(
                                        mainAxisAlignment:MainAxisAlignment.spaceAround,   
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text('Email',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: const Color.fromARGB(255, 255, 255, 255)
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Container(
                                            padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                width: 0.6,
                                                color: Color.fromARGB(255, 255, 255, 255)
                                    
                                              ),
                                              borderRadius: BorderRadius.circular(10)
                                            ),
                                            child: TextFormField(
                                              controller: esqueciSenhaController.email,
                                              decoration: InputDecoration(

                                                border: InputBorder.none,
                                                prefixIcon: Icon(Icons.mail_outline,color: Color.fromARGB(255, 243, 50, 2),)

                                              ),
                                              
                                            ),
                                          ),
                                          SizedBox(
                                            height: 25,
                                          ),
                                              

                                          GestureDetector(
                                            onTap: (){
                                              esqueciSenhaController.esqueciSenha(context);    
                                            },
                                            child: Center(
                                              child: Container(
                                                padding: EdgeInsets.fromLTRB(35,10,35,10),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Color.fromARGB(222, 243, 91, 2),
                                                ),
                                                child: Text('Enviar email',style: TextStyle(color: Color.fromARGB(255, 255, 255, 255)),),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
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
                  return Text('erro');
                }
              } else if (snapshot.hasError) {
                return Text('Erro ao carregar a tela: ${snapshot.error}');
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
