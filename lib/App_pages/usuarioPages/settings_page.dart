import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/componentesOngPerfil/ongPhoto.dart';
import 'package:replica_google_classroom/App_pages/componentesOngPerfil/picFeed.dart';
import 'package:replica_google_classroom/services/mongodb.dart';

class SettingsPageController extends GetxController {
  //variaveis 
  var usuario;

  RxInt nunmeroDePostagens = 0.obs;
  RxInt nunmeroDeAdocoes = 0.obs;
  RxInt opcao = 0.obs;
  String nomeOng = 'Ong dos animais\nperdidos asfdsa';
  String localizacao = 'Surubim, PE';
  RxString bio = 'somos uma Ong dedicada ao cuidado de pets.'.obs;
  dynamic info = [];
  dynamic info2 = [];
  late String emailOng;
  var imagembd;
  File? imageFile; // imagem para ser coletada e inserida no banco para o perfil 
  File? imageFileFeed; // imagem para ser coletada e inserida no banco para o feed 

  
  Future<String> func() async {
    usuario = await MongoDataBase.retornaOngCompleta('allan.miller@upe.br');
    nomeOng = usuario['nomeOng'];
    localizacao = '${usuario['cidade']},${usuario['estado']}'; 
    imagembd = usuario['imagemPerfil'];
    bio.value = usuario['bio'];
    info = usuario['feedImagens'];
    info2 = usuario['petList'];
    emailOng = usuario['email'];

    // ignore: prefer_conditional_assignment
    if(info == null){
      info2 = [];
      info = [];
    }else{
      nunmeroDePostagens.value = info.length;
    }

    print(info2);
    
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
    };

    for (int i = 0; i < conteudo.length; i += 3) {
      List<Widget> rowChildren = [];
      for (int j = i; j < i + 3 && j < conteudo.length; j++) {
        rowChildren.add(
          GestureDetector(
            onTap: () {
              if(feed == 1){
                Get.toNamed('/imageViewerPage',arguments: [conteudo[j]]);
              }else{
                feed = feed;
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
                  Get.toNamed('/OngInfoEditPage');
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
  SettingsPage({Key? key}) : super(key: key);
  var settingsPageController = Get.put(SettingsPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SettingsPageController>(
        init: SettingsPageController(),
        builder: (_) {
          return Scaffold(
            floatingActionButton: FloatingActionButton(onPressed: () async {
              settingsPageController.showBottomSheetFeed(context);
            },child: Icon(Icons.add,color: Color.fromARGB(255, 55, 98, 227),),),
            body: FutureBuilder(
              future: settingsPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Stack(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                height: 320,
                                decoration: const BoxDecoration(
                                image: DecorationImage(image: AssetImage('assets/fundoOng.png'),fit: BoxFit.cover)
                              ),
                              

                              ),
                              Container(
                              height: MediaQuery.of(context).size.height * 0.4,                                
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(15,0,15,0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        OngPhoto(onPressed: (){settingsPageController.showBottomSheet(context);}, image: settingsPageController.imageFile,imagembd: settingsPageController.imagembd),
                                        Container(
                                          height: MediaQuery.of(context).size.height *0.25,
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                               Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(settingsPageController.nomeOng,style: const TextStyle(fontSize: 20),),
                                                  Row(
                                                    children: [
                                                      Text(settingsPageController.localizacao),
                                                      Icon(Icons.place),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.fromLTRB(0,5,0,5),
                                                child: Container(
                                                  height: 1,
                                                  width: MediaQuery.of(context).size.width * 0.48,// Largura da "linha"
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
                                                            Obx(()=> Text(settingsPageController.nunmeroDePostagens.toString(),style: TextStyle(fontSize: 20),)),
                                                            Text('publicações',style: TextStyle(fontSize: 12),),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.fromLTRB(0,0,10,0),
                                                        child: Column(
                                                          children: [
                                                            Text(settingsPageController.nunmeroDeAdocoes.toString(),style: TextStyle(fontSize: 20),),
                                                            Text('Adoções',style: TextStyle(fontSize: 12)),
                                                          ],
                                                        ),
                                                      ),
                                                       Padding(
                                                        padding: const EdgeInsets.fromLTRB(0,0,0,0),
                                                        child: Column(
                                                          children: [
                                                            Text(settingsPageController.nunmeroDeAdocoes.toString(),style: TextStyle(fontSize: 20),),
                                                            Text('Curtidas',style: TextStyle(fontSize: 12)),
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
                                                  width: MediaQuery.of(context).size.width * 0.48,// Largura da "linha"
                                                  color: Colors.black, // Cor da "linha"
                                                ),
                                              ),
                                              Container(
                                                height: 35,
                                                width: MediaQuery.of(context).size.width * 0.50,
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    ElevatedButton(
                                                      onPressed: (){
                                                        settingsPageController.showBottomSheetEdit(context);
                                                      },
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: const Color.fromARGB(255, 255, 94, 0),
                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5)))
                                                      ),
                                                      child:  const Text('Editar perfil',style: TextStyle(color:  Color.fromARGB(255, 255, 255, 255)),)),
                                                  ],
                                                ),
                                              )
                                                                            
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ],
                            
                          ),
                          // define um limite maximo de caracteres que o texto pode ter na tela
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            height: MediaQuery.of(context).size.height*0.1,
                            child: SingleChildScrollView(
                                child: Obx(
                                  ()=>Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(settingsPageController.bio.value),
                                    ],
                                  ),
                                )
                                )
                          ),
                      
                          Container(
                            height: MediaQuery.of(context).size.height * 0.41,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Container(
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
                                               backgroundColor: Color.fromARGB(255, 255, 255, 255),
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
                                    height: MediaQuery.of(context).size.height * 0.37,
                                    color: const Color.fromARGB(255, 255, 255, 255),
                                    child: SingleChildScrollView(
                                      child: settingsPageController.opcao == 0 ? Column(
                                         children: settingsPageController.mostraFeed(context,settingsPageController.info,1),
                                      ) : 
                                      Column(
                                         children: settingsPageController.mostraFeed(context,settingsPageController.info2,2),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return Text('Nenhum pet disponível');
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
