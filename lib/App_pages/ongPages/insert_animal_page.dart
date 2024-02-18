// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_typing_uninitialized_variables

import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:replica_google_classroom/App_pages/app_widgets/sem_internet.dart';
import 'package:replica_google_classroom/controller/userController.dart';
import 'package:replica_google_classroom/services/banco/firebase.dart';
import 'listas.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:replica_google_classroom/entitites/animal.dart';
import 'package:replica_google_classroom/widgets/load_Widget.dart';
import '../app_widgets/pet_register_widgets/tipo_animal_buttom.dart';
import '../app_widgets/pet_register_widgets/drop_down.dart';
import '../app_widgets/pet_register_widgets/photo_container.dart';


class InsertAnimalController extends GetxController {
  var selectedType = '0'.obs;
  var nome = TextEditingController();
  var selectedTypeSex = 'Sexo'.obs;
  var selectedSize = "Porte".obs;
  var selectedAge = 'Idade'.obs;
  var selectedRace = 'Raça'.obs;
  var selectedListRace = racasDeCachorro.obs;
  File? imageFile;
  late MeuControllerGlobal meuControllerGlobal;
  late var usuario;

 func() async {
  meuControllerGlobal = Get.find();

  if(meuControllerGlobal.internet.value){
      // quando puxa do banco de dados, se tiver vazio(null), atribui uma lista vazia 
      return 'allan';
    }
  }

  Future<String> cadastrar(context) async {
    //coletar os dados do campos de input e instanciar um animal
    showLoad(context);
    var animal = Animal(
      tipo: selectedType.value,
      sexo: selectedTypeSex.value,
      nome: nome.text,
      porte: selectedSize.value,
      idade: selectedAge.value,
      raca: selectedRace.value
    );


    Map<String, dynamic> animalData = animal.toMap();

    animalData['Imagem'] = imageFile;
    animalData['Em processo de adoção'] = false;

    String retorno = animal.validaCampos(imageFile);
    if (retorno == '') {
      await BancoDeDados.adicionarPet(animalData, meuControllerGlobal.usuario['Id']);

    }
    Get.back();
    return retorno;
  }

  void pick(ImageSource source) async {
    final imagePicker = ImagePicker();
    final pickedFile = await imagePicker.pickImage(source: source);
    if (pickedFile != null) {
      imageFile = File(pickedFile.path);
      update();
    }
  }

  void resetaCampos() {
    selectedType = '0'.obs;
    nome.clear();
    selectedTypeSex = 'Sexo'.obs;
    selectedSize = "Porte".obs;
    selectedAge = 'Idade'.obs;
    selectedRace = 'Raça'.obs;
    selectedListRace = racasDeCachorro.obs;
    imageFile = null;
    update();
  }

  void showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          // Conteúdo do BottomSheet
          height: 200,

          child: Column(
            children: [
              ListTile(
                title: Text(
                  'Inserir uma foto',
                  style: TextStyle(
                      fontSize: 25,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
              ),
              ListTile(
                title: Text(
                  'Galeria',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: Icon(
                  Icons.photo,
                  color: Color.fromARGB(255, 255, 84, 16),
                ),
                onTap: () {
                  pick(ImageSource.gallery);
                },
              ),
              ListTile(
                title: Text(
                  'Camera',
                  style: TextStyle(
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Medium'),
                ),
                leading: Icon(
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
}

// ignore: must_be_immutable
class InsertAnimalPage extends StatelessWidget {
  InsertAnimalPage({super.key});
  var insertAnimalController = Get.put(InsertAnimalController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<InsertAnimalController>(
        init: InsertAnimalController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: insertAnimalController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return Stack(
                    children: [
                      Image.asset(
                        "assets/fundoCadastro2.png",
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                              width: double.infinity,
                              height: 165,
                              color: Color.fromARGB(255, 255, 255, 255),
                              child: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 130,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 255, 51, 0),
                                      borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20)
                                      )
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 250,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: AssetImage('assets/5.png'),
                                                fit: BoxFit.cover)
                                          ),
                                        ),
                                      ],
                                    )
                                  ),
                                  Positioned(
                                    top: 95,
                                    left: 15,
                                    child: Card(
                                      elevation: 8,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:BorderRadius.all(Radius.circular(30))  
                                      ),
                                      child: Container(
                                        width: MediaQuery.of(context).size.width * 0.9,
                                        height: 55,
                                        decoration: BoxDecoration(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                          borderRadius: BorderRadius.all(Radius.circular(30))     
                                        ),
                                        child: Row(
                                          mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                                              child: Text(
                                                'cadastrar ',
                                                style: TextStyle(fontSize: 20,fontFamily:'AsapCondensed-Light'),         
                                              ),
                                            ),
                                            Container(
                                              width: 55,
                                              height: 55,
                                              decoration: BoxDecoration(
                                                color:Color.fromARGB(255, 17, 61, 94),
                                                borderRadius:BorderRadius.circular(40)
                                              ),     
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(30.0, 30, 30.0, 0),
                                  child:Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(bottom: 10),
                                      
                                      ),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(5.0),
                                        child: Container(
                                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                          color: Color.fromARGB(88, 241, 231, 231),
                                          height: 320,
                                          width: double.infinity,
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                                            child: Column(
                                              mainAxisAlignment:MainAxisAlignment.spaceAround, 
                                              children: [
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,                                             
                                                  children: [
                                                    PhotoContainer(
                                                      onPressed: () {
                                                        insertAnimalController.showBottomSheet(context);   
                                                      },
                                                      image:insertAnimalController.imageFile,
                                                      tipo: 2
                                                          
                                                    ),
                      
                                                    Column(
                                                      crossAxisAlignment:CrossAxisAlignment.start,
 
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets.fromLTRB(0, 0, 0, 15),    
                                                          child: Container(
                                                            width: 150,
                                                            height: 80,
                                                            decoration: BoxDecoration(
                                                                border: Border.all(
                                                                  color:const Color.fromARGB(255,110,110,110), width: 0.1,),
                                                                  borderRadius:BorderRadius.circular(10),    
                                                                  color: Colors.transparent),
                                                            child: Column(
                                                              mainAxisAlignment:MainAxisAlignment.spaceAround,  
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:MainAxisAlignment.center,        
                                                                  children: [
                                                                    Text('Selecione o tipo')
                                                                  ],
                                                                ),
                                                                Row(
                                                                  children: [
                                                                    TipoAnimalButton(
                                                                      imagePath:"assets/doguinho.png",   
                                                                      onPressed: () {
                                                                        insertAnimalController.selectedType.value = '1';    
                                                                        insertAnimalController.selectedListRace.value = racasDeCachorro;     
                                                                      },
                                                                      tipo: '1',
                                                                      selectedType:insertAnimalController.selectedType,            
                                                                    ),
                                                                    TipoAnimalButton(
                                                                      imagePath:"assets/gatinho.png",
                                                                          
                                                                      onPressed: () {
                                                                        insertAnimalController.selectedType.value = '2';
                                                                        insertAnimalController.selectedListRace.value = racasDeGato;   
                                                                      },
                                                                      tipo: '2',
                                                                      selectedType:insertAnimalController.selectedType,          
                                                                    ),
                                                                    TipoAnimalButton(
                                                                      imagePath:"assets/passarinho.png",  
                                                                      onPressed: () {
                                                                        insertAnimalController.selectedType.value = '3';
                                                                        insertAnimalController.selectedListRace.value = avesDeEstimacao;                                                              
                                                                      },
                                                                      tipo: '3',
                                                                      selectedType:insertAnimalController.selectedType,           
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                        Container(
                                                          width: 150,
                                                          height: 30,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                color: const Color.fromARGB(255, 110, 110, 110),       
                                                                width: 0.4,
                                                              ),
                                                              borderRadius:
                                                                BorderRadius.circular(10),
                                                                color: Colors.transparent
                                                              ),
                                                          child: Row(
                                                            mainAxisAlignment:MainAxisAlignment.center,
                                                            children: [
                                                              CustomDropdownButton(
                                                                items: sexoList,
                                                                controller:insertAnimalController.selectedTypeSex,       
                                                              ),
                                                            ],
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                Container(
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color.fromARGB(255, 110, 110, 110),
                                                      width: 0.4,
                                                    ),
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),   
                                                  ),
                                                  child: TextFormField(
                                                    controller: insertAnimalController.nome,
                                                    decoration: InputDecoration(
                                                      hintText: 'Nome do Pet',
                                                      hintStyle: TextStyle(
                                                        color: const Color.fromARGB(255, 27, 27, 27),  
                                                        fontWeight: FontWeight.w200,
                                                        fontSize: 18,
                                                      ),
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                        const EdgeInsets.fromLTRB(10, 8, 0, 10),   
                                                    ),
                                                  ),
                                                ),
                                                Container(
                                                  width: double.infinity,
                                                  height: 40,
                                                  decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: const Color.fromARGB(255, 110, 110, 110),  
                                                      width: 0.4,
                                                    ),
                                                    color: Colors.transparent,
                                                    borderRadius: BorderRadius.all(Radius.circular(10)),  
                                                  ),
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      CustomDropdownButton(
                                                        items: portes,
                                                        controller: insertAnimalController.selectedSize,  
                                                      ),
                                                      CustomDropdownButton(
                                                        items: idades,
                                                        controller: insertAnimalController.selectedAge, 
                                                      ),
                                                      CustomDropdownButton(
                                                        items: insertAnimalController.selectedListRace, 
                                                        controller: insertAnimalController.selectedRace, 
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Row(
                                                  mainAxisAlignment:MainAxisAlignment.center,
                                                  children: [
                                                    CustomIconButton(
                                                      label: 'Cadastre',
                                                      onPressed: () async {
                                                        // ignore: use_build_context_synchronously
                                                        String retorno = await insertAnimalController.cadastrar(context);
                                                        if (retorno != "") {
                                                          mySnackBar(retorno, false);
                                                        }
                                                        else {
                                                          mySnackBar('Cadastro feito com sucesso!',true);    
                                                          insertAnimalController.resetaCampos();     
                                                        }
                                                      },
                                                      width: 200,
                                                      alinhamento: MainAxisAlignment.center,
                                                      raio: 10,
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                               
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                 
                  } else {
                    return const SemInternetWidget();
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



