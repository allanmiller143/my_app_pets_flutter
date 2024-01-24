// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, unnecessary_string_escapes, avoid_function_literals_in_foreach_calls, avoid_print

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';

class ChatController extends GetxController {
  late MeuControllerGlobal meuControllerGlobal;
  RxBool barraDePesquisa = false.obs;
  var nome = TextEditingController();
  var queryResultado = [];
  var tempSearchStore = [];
  var temp = [];
  late String meuNome;
  late String meuEmail;
  late String meuId;
  List<Widget> listachats = [];
  Stream<QuerySnapshot<Map<String, dynamic>>>? stream;
  var listaDeIds = [];
  File? imageFile;

  getChatrooms() async {
    stream = (await BancoDeDados.getChatRooms(meuId)) as Stream<QuerySnapshot<Map<String, dynamic>>>?;
    stream?.listen((QuerySnapshot<Map<String, dynamic>> snapshot) async {
      listachats.clear();
      listaDeIds.clear();

      if (snapshot.docs.isNotEmpty) {
        for (DocumentSnapshot<Map<String, dynamic>> ds in snapshot.docs) {
          var idContato = '';
          if (ds.data()?['users'][0] == meuId) {
            idContato = ds.data()?['users'][1];
          } else {
            idContato = ds.data()?['users'][0];
          }
          var user = await BancoDeDados.getUsuarioPorId(idContato);
          var info = {
            'ultimaMensagem': ds.data()?['ultimaMensagem'],
            'Id': idContato,
            'ultimaMensagemTs': ds.data()?['ultimaMensagemTs'],
            'Nome': user.docs[0]['Nome'],
            'ImagemPerfil': user.docs[0]['ImagemPerfil'],
          };

          if (!listaDeIds.contains(idContato)) {
            listachats.add(contruirCard(info));
            listaDeIds.add(idContato);
          }
          barraDePesquisa.value = !barraDePesquisa.value;
          barraDePesquisa.value = !barraDePesquisa.value;
        }
      }
    });
  }

  getChatRoomByUserName(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  Widget contruirCard(info) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
      child: GestureDetector(
        onTap: () async {
          barraDePesquisa.value = false;
          tempSearchStore = [];
          queryResultado = [];

          var chatRoomId = getChatRoomByUserName(meuId, info['Id']); // quem envia e quem recebe
          Map<String, dynamic> chatRoomInfoMap = {
            'users': [meuId, info['Id']],
          };

          await BancoDeDados.criaChatRoom(chatRoomId, chatRoomInfoMap);
          Get.toNamed('/chatConversa', arguments: [info['Id'], info['Nome']]);
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: SizedBox(
                    height: 60,
                    width: 60,
                    child: info['ImagemPerfil'] != ''
                        ? Image.network(
                            info['ImagemPerfil'],
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          )
                        : Image.asset(
                            'assets/eu.png',
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      info['Nome'],
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),

                    info['ultimaMensagem'] != null
                        ? SizedBox(
                            width: 180,
                            child: Text(
                              info['ultimaMensagem'],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontWeight: FontWeight.w300,
                                  fontSize: 14,
                                  color: Colors.black),
                            ),
                          )
                        : Text(
                            'Digite uma mensagem',
                            style: TextStyle(
                                fontWeight: FontWeight.w100, fontSize: 14),
                          ),
                  ],
                ),
              ],
            ),
            info['ultimaMensagemTs'] != null
                ? Text(
                    info['ultimaMensagemTs'],
                    style: TextStyle(
                        fontWeight: FontWeight.w400, fontSize: 12),
                  )
                : SizedBox()
          ],
        ),
      ),
    );
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>?> func() async {
    meuControllerGlobal = Get.find();
    meuNome = meuControllerGlobal.usuario['Nome'];
    meuEmail = meuControllerGlobal.usuario['E-mail'];
    meuId = meuControllerGlobal.usuario['Id'];
    await getChatrooms();
    return stream;
  }
}

class ChatPage extends StatelessWidget {
  ChatPage({super.key});
  var chatController = Get.put(ChatController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<ChatController>(
        builder: (_) {
          return Scaffold(
            backgroundColor: Color.fromARGB(222, 243, 91, 2),
            body: FutureBuilder(
              future: chatController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
                          width: double.infinity,
                          height:
                              MediaQuery.of(context).size.height * 0.15,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                child: GestureDetector(
                                  onTap: () {},
                                  child: Row(
                                    children: [
                                      Text(
                                        chatController
                                            .meuControllerGlobal.usuario['Nome'],
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 255, 255, 255),
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                vertical: 20, horizontal: 10),
                            decoration: BoxDecoration(
                                color:
                                    Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(20),
                                    topRight: Radius.circular(20))),
                            child: Obx(
                              () => Column(
                                children: [
                                  (chatController.barraDePesquisa.value ==
                                              true &&
                                          chatController
                                              .tempSearchStore.isNotEmpty)
                                      ? SingleChildScrollView(
                                          child: ListView(
                                            primary: false,
                                            shrinkWrap: true,
                                            children: chatController
                                                .tempSearchStore
                                                .map((e) {
                                              return chatController
                                                  .contruirCard(e);
                                            }).toList(),
                                          ),
                                        )
                                      : SingleChildScrollView(
                                          child: Column(
                                          children: chatController.listachats,
                                        )),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    );
                  } else {
                    return Text('erro');
                  }
                } else if (snapshot.hasError) {
                  return Text('Erro ao carregar a tela: ${snapshot.error}');
                } else {
                  return Center(
                      child: CircularProgressIndicator(
                    color: Color.fromARGB(255, 253, 72, 0),
                  ));
                }
              },
            ),
          );
        },
      ),
    );
  }
}
