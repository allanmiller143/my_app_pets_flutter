
// ignore_for_file: prefer_typing_uninitialized_variables, must_be_immutable

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/ongPhoto.dart';
import 'package:replica_google_classroom/App_pages/ongPages/componentesOngPerfil/customImagemFeed.dart';
import 'package:replica_google_classroom/loginPages/my_password_page.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class SettingsPageController extends GetxController {
  //variaveis 
  var usuario;
  RxInt nunmeroDePostagens = 0.obs;
  RxInt nunmeroDeAdocoes = 0.obs;
  RxInt opcao = 0.obs;
  RxString nomeOng = ''.obs;
  RxString localizacao = 'Surubim, PE'.obs;
  RxString bio = ''.obs;
  dynamic info = [];
  dynamic petsInfo = [];
  late String emailOng;
  var imagembd;
  File? imageFile; // imagem para ser coletada e inserida no banco para o perfil 
  File? imageFileFeed; // imagem para ser coletada e inserida no banco para o feed
  late SenhaController senhaController;
  bool args = false; // serve para controlar as funções de usuario e ong 

  
  Future<String> func() async {

    if(Get.arguments == null){
      senhaController = Get.find();
      usuario = senhaController.usuario;
    }else{
      args = true;
      usuario = Get.arguments[0];
    }
    localizacao.value = '${usuario['cidade']},${usuario['estado']}'; 
    nomeOng.value = usuario['nomeOng'];
    imagembd = usuario['imagemPerfil'];
    bio.value = usuario['bio'];
    info = usuario['feedImagens'];
    petsInfo = usuario['petList'];
    emailOng = usuario['email'];


    // quando puxa do banco de dados, se tiver vazio(null), atribui uma lista vazia 
    if(info == null){
      petsInfo = [];
      info = [];
    }else{
      nunmeroDePostagens.value = info.length;
    }

    
   
    return 'allan';
  }
  List<Widget> mostraFeed(context,conteudo,feed) {
    List<Widget> rows = [];
    if(conteudo.length == 0){
        rows.add(
          const Padding(
            padding: EdgeInsets.fromLTRB(0,50,0,0),
            child: Center(child: Text("Esta Página ainda não possui\npublicações",style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),),
          )
      );
      return rows;
    }

    for (int i = 0; i < conteudo.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 3 && j < conteudo.length; j++) {
        rowChildren.add(
          GestureDetector(
            onTap: () {
              if(feed == 1){
                Get.toNamed('/imageViewerPage',arguments: [conteudo[j],1]);
              }else{
                Get.toNamed('/imageViewerPage',arguments: [conteudo[j],2]);
              }
              
            },
            
            child: feed == 1 ? PicFeed(image: conteudo[j]):PicFeed(petInfo: conteudo[j])
          )
        );
      }
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: rowChildren,
        ),
      );
    }

    return rows;
}
  void showBottomSheetEdit(BuildContext context) async {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // Conteúdo do BottomSheet
          height: 200,
          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Editar Perfil',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title:const  Text(
                  'Informações de Perfil',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                   var infoEditavel = {
                      'Nome' : usuario['nomeOng'],
                      'Telefone': usuario['telefone'],
                      'Senha': usuario['password'],
                      'Nome representante': usuario['nome representante'],
                      'Endereço': {
                        'cidade': usuario['cidade'],
                        'rua': usuario['rua'],
                        'numero': usuario['numero'],
                        'estado': usuario['estado'],
                        'bairro': usuario['bairro'],
                        'cep': usuario['cep']
                      },
                      'Email': usuario['email'],
                      'CNPJ' : usuario['cnpj'],
                      'Email representante': usuario['email representante'],
                      'CPF representante' : usuario['cpf representante']



                    };
                  Get.toNamed('/OngInfoEditPage',arguments: [infoEditavel]);
                },
              ),
              ListTile(
                title: const Text(
                  'Bio',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading:const  Icon(
                  Icons.text_snippet_rounded,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  Get.toNamed('/ongEditBioProfilePage');
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      Uint8List imageBytes = await imageFile!.readAsBytes(); // Converta a imagem em um array de bytes 
      String base64Image = base64Encode(imageBytes); // Codifique os bytes em formato base64 (opcional)
      update();
      await MongoDataBase.insereImagemPerfil(emailOng, base64Image); 


      
    }
  }
  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Conteúdo do BottomSheet
          height: 200,

          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Inserir uma foto',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title: const Text(
                  'Galeria',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                title: const Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }
  void showBottomSheetFeed(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          // Conteúdo do BottomSheet
          height: 200,

          child: Column(
            children: [
              const ListTile(
                title: Text(
                  'Inserir uma foto',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title: const Text(
                  'Galeria',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pickFeed(ImageSource.gallery);
                },
              ),
              ListTile(
                title: const Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: const Icon(
                  Icons.camera_alt,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pickFeed(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );
  }  
  void pickFeed(ImageSource source) async {
  final imagePicker = ImagePicker();
  final pickedFile = await imagePicker.pickImage(source: source);
  if (pickedFile != null) {
    imageFileFeed = File(pickedFile.path); 
    Uint8List imageBytes = await imageFileFeed!.readAsBytes(); // Converta a imagem em um array de bytes 
    String base64Image = base64Encode(imageBytes); // Codifique os bytes em formato base64 (opcional)
    info.add(base64Image);
    nunmeroDePostagens.value += 1;
    opcao.value = 1;
    opcao.value = 0;
    await MongoDataBase.insereImagemFeed('allan.miller@upe.br', base64Image);
    
  }
}

}

class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  var settingsPageController = Get.put(SettingsPageController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SettingsPageController>(
        init: SettingsPageController(),
        builder: (_) {
          return Scaffold(
            
            floatingActionButton: settingsPageController.args == true ? FloatingActionButton(onPressed: () async {
              settingsPageController.showBottomSheetFeed(context);
            },child: const Icon(Icons.add,color: Color.fromARGB(255, 55, 98, 227),),): const SizedBox(),
            body: FutureBuilder(
              future: settingsPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                          height: MediaQuery.of(context).size.height * 0.4,                                
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(15,0,15,0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: MediaQuery.of(context).size.height *0.15,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: MediaQuery.of(context).size.height *0.015,

                                      ),
                                      GestureDetector(
                                        onTap: (){
                                          Get.back();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                                          height: MediaQuery.of(context).size.height *0.075,
                                          width: MediaQuery.of(context).size.width *0.5,
                                          decoration: const BoxDecoration(
                                            
                                            image: DecorationImage(image: AssetImage('assets/minhaLogo.png'))
                                          ),
                                        
                                        ),
                                      ),
                                    ],
                                  ),

                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    OngPhoto(onPressed: (){settingsPageController.showBottomSheet(context);}, image: settingsPageController.imageFile,imagembd: settingsPageController.imagembd,args: settingsPageController.args,),
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height *0.25,
                                      width: MediaQuery.of(context).size.width *0.52,
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                            Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Obx(()=> Text(
                                                settingsPageController.nomeOng.value,
                                                style: const TextStyle(fontSize: 20),
                               
                                                )
                                              ),
                                              Row(
                                                children: [
                                                  Obx(()=> Text(settingsPageController.localizacao.value)),
                                                  const Icon(Icons.place),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,5,0,5),
                                            child: Container(
                                              height: 1,
                                              width: MediaQuery.of(context).size.width *0.52,
                                              color: Colors.black, // Cor da "linha"
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                    child: Column( 
                                                      children: [
                                                        Obx(()=> Text(settingsPageController.nunmeroDePostagens.toString(),style: const TextStyle(fontSize: 20),)),
                                                        GestureDetector(
                                                          onTap: (){
                                                            print('aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa');
                                                            print(settingsPageController.senhaController.pets[0]['nomeOng']);

                                                          },
                                                          child: Text('publicações',style: TextStyle(fontSize: 12),)),
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                    child: Column(
                                                      children: [
                                                        Text(settingsPageController.nunmeroDeAdocoes.toString(),style: const TextStyle(fontSize: 20),),
                                                        const Text('Adoções',style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ),
                                                    Padding(
                                                    padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                                    child: Column(
                                                      children: [
                                                        Text(settingsPageController.nunmeroDeAdocoes.toString(),style: const TextStyle(fontSize: 20),),
                                                        const Text('Curtidas',style: TextStyle(fontSize: 12)),
                                                      ],
                                                    ),
                                                  ), 
                                                ],
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(0,5,0,5),
                                            child: Container(
                                              height: 1,
                                              width: MediaQuery.of(context).size.width *0.52,
                                              color: Colors.black, // Cor da "linha"
                                            ),
                                          ),
                                          
                                          settingsPageController.args == false ?
                                          SizedBox(
                                            height: 35,
                                            width: MediaQuery.of(context).size.width * 0.52,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.end,
                                              children: [
                                                ElevatedButton(
                                                  onPressed: (){
                                                    settingsPageController.showBottomSheetEdit(context);
                                                  },
                                                  style: ElevatedButton.styleFrom(
                                                    backgroundColor: const Color.fromARGB(255, 255, 94, 0),
                                                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                                                  ),
                                                  child:  const Text('Editar perfil',style: TextStyle(color:Color.fromARGB(255, 255, 255, 255)),)),
                                              ],
                                            ),
                                          ):const SizedBox(),
                                                                        
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                          // define um limite maximo de caracteres que o texto pode ter na tela
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0,5,0,0),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.9,
                              height: MediaQuery.of(context).size.height*0.08,
                              child: SingleChildScrollView(
                                  child: Obx(
                                    ()=>Row(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.9,
                                          child: Text(
                                            settingsPageController.bio.value,
                                          ),
                                        )
                                                                  
                                      ],
                                    ),
                                  )
                                  )
                            ),
                          ),
                      
                          SizedBox(
                            height: (Get.arguments == null) ?MediaQuery.of(context).size.height * 0.43 : MediaQuery.of(context).size.height * 0.5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 SizedBox(
                                  width: double.infinity,
                                  height: MediaQuery.of(context).size.height * 0.04,     
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(15,4,15,4),
                                        child: Obx(()=> SizedBox(
                                          width: 110,
                                          child: 
                                          settingsPageController.opcao.value == 0 ?
                                          ElevatedButton(
                                            onPressed: (){ 
                                              settingsPageController.opcao.value = 0;
                                            },
                                            style: ElevatedButton.styleFrom(
                                               backgroundColor: const Color.fromARGB(255, 255, 94, 0),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                              ),
                                              child:  const Text('Feed',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),)
                                            ):
                                            ElevatedButton(
                                            onPressed: (){
                                              settingsPageController.opcao.value = 0;
                                            },
                                            style: ElevatedButton.styleFrom(
                                               backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))
                                              ),
                                              child:  const Text('Feed',style: TextStyle(color:  Color.fromARGB(255, 255, 94, 0),),)
                                            )
                                          )
                                        ),
                                      ),
                                      Obx(
                                        ()=> Padding(
                                          padding: const EdgeInsets.fromLTRB(15,4,15,4),
                                          child: settingsPageController.opcao.value == 1 ? 
                                          SizedBox(width: 110,child: ElevatedButton(onPressed: (){settingsPageController.opcao.value = 1;},style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 94, 0),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), child:  const Text('Pets',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),))):
                                          SizedBox(width: 110,child: ElevatedButton(onPressed: (){settingsPageController.opcao.value = 1;},style: ElevatedButton.styleFrom(backgroundColor: const Color.fromARGB(255, 255, 255, 255),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))), child:  const Text('Pets',style: TextStyle(color:  Color.fromARGB(255, 255, 94, 0)),))),
                                        ),
                                      ),
                                    ],
                                    
                                  ),
                                ),
                                Obx(
                                  () => Container(
                                  height: (Get.arguments == null) ?MediaQuery.of(context).size.height * 0.39 : MediaQuery.of(context).size.height * 0.45,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    child: SingleChildScrollView(
                                      child: settingsPageController.opcao.value == 0 ? Column(
                                         children: settingsPageController.mostraFeed(context,settingsPageController.info,1),
                                      ) : 
                                      Column(
                                         children: settingsPageController.mostraFeed(context,settingsPageController.petsInfo,2),
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
                    return const Text('Nenhum pet disponível');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a lista de pets: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 253, 72, 0),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
