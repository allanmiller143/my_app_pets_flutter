// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
//import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'listas.dart';
import 'package:replica_google_classroom/widgets/mybutton.dart';
import 'package:replica_google_classroom/entitites/animal.dart';
import 'package:replica_google_classroom/widgets/load_Widget.dart';
import '../services/mongodb.dart';

class InsertAnimalController extends GetxController {
  var selectedType = '0'.obs;
  var nome = TextEditingController();
  var selectedTypeSex = 'Sexo'.obs;
  var selectedSize = "Porte".obs;
  var selectedAge = 'Idade'.obs;
  var selectedRace = 'Raça'.obs;
  var selectedListRace = racasDeCachorro.obs;
  File? imageFile;

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

    if (imageFile != null) {
      Uint8List imageBytes = await imageFile!.readAsBytes(); // Converta a imagem em um array de bytes
          
      String base64Image = base64Encode(imageBytes); // Codifique os bytes em formato base64 (opcional)
          
      animal.imagem = base64Image; // Adicione a imagem codificada ao mapa de dados do animal
          
    }

    Map<String, dynamic> animalData = animal.toMap();
    String retorno = animal.validaCampos();
    if (retorno == '') {
      await MongoDataBase.inserePet('55340297000126', animalData);
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
        return Container(
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

class InsertAnimalPage extends StatelessWidget {
  InsertAnimalPage({Key? key}) : super(key: key);
  final insertAnimalController = Get.put(InsertAnimalController());
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<InsertAnimalController>(
        init: InsertAnimalController(),
        builder: (_) {
          return Scaffold(
            body: Stack(
              children: [
                Image.asset(
                  "assets/fundoCadastro2.png",
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(40.0, 10, 40.0, 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                                  child: Text(
                                    'Vamos cadastrar!',
                                  ),
                                ),
                              ],
                            ),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        PhotoContainer(
                                          onPressed: () {
                                            insertAnimalController
                                                .showBottomSheet(context);
                                          },
                                          image:
                                              insertAnimalController.imageFile,
                                        ),

                                        //insertAnimalController.imageFile !=null? FileImage(insertAnimalController.imageFile!): null
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 15),
                                              child: Container(
                                                width: 150,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color:
                                                          const Color.fromARGB(
                                                              255,
                                                              110,
                                                              110,
                                                              110),
                                                      width: 0.1,
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.transparent),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceAround,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text('Selecione o tipo')
                                                      ],
                                                    ),
                                                    Row(
                                                      children: [
                                                        TipoAnimalButton(
                                                          imagePath:
                                                              "assets/doguinho.png",
                                                          onPressed: () {
                                                            insertAnimalController
                                                                .selectedType
                                                                .value = '1';
                                                            insertAnimalController
                                                                    .selectedListRace
                                                                    .value =
                                                                racasDeCachorro;
                                                          },
                                                          tipo: '1',
                                                          selectedType:
                                                              insertAnimalController
                                                                  .selectedType,
                                                        ),
                                                        TipoAnimalButton(
                                                          imagePath:
                                                              "assets/gatinho.png",
                                                          onPressed: () {
                                                            insertAnimalController
                                                                .selectedType
                                                                .value = '2';
                                                            insertAnimalController
                                                                    .selectedListRace
                                                                    .value =
                                                                racasDeGato;
                                                          },
                                                          tipo: '2',
                                                          selectedType:
                                                              insertAnimalController
                                                                  .selectedType,
                                                        ),
                                                        TipoAnimalButton(
                                                          imagePath:
                                                              "assets/passarinho.png",
                                                          onPressed: () {
                                                            insertAnimalController
                                                                .selectedType
                                                                .value = '3';
                                                            insertAnimalController
                                                                    .selectedListRace
                                                                    .value =
                                                                avesDeEstimacao;
                                                          },
                                                          tipo: '3',
                                                          selectedType:
                                                              insertAnimalController
                                                                  .selectedType,
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
                                                    color: const Color.fromARGB(
                                                        255, 110, 110, 110),
                                                    width: 0.4,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  color: Colors.transparent),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  CustomDropdownButton(
                                                    items: sexoList,
                                                    controller:
                                                        insertAnimalController
                                                            .selectedTypeSex,
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
                                          color: const Color.fromARGB(
                                              255, 110, 110, 110),
                                          width: 0.4,
                                        ),
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: TextFormField(
                                        controller: insertAnimalController.nome,
                                        decoration: InputDecoration(
                                          hintText: 'Nome do Pet',
                                          hintStyle: TextStyle(
                                            color: const Color.fromARGB(
                                                255, 27, 27, 27),
                                            fontWeight: FontWeight.w200,
                                            fontSize: 18,
                                          ),
                                          border: InputBorder.none,
                                          contentPadding:
                                              const EdgeInsets.fromLTRB(
                                                  10, 8, 0, 10),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 110, 110, 110),
                                          width: 0.4,
                                        ),
                                        color: Colors.transparent,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                      ),
                                      child: Row(
                                        children: [
                                          CustomDropdownButton(
                                            items: portes,
                                            controller: insertAnimalController
                                                .selectedSize,
                                          ),
                                          CustomDropdownButton(
                                            items: idades,
                                            controller: insertAnimalController
                                                .selectedAge,
                                          ),
                                          CustomDropdownButton(
                                            items: insertAnimalController
                                                .selectedListRace,
                                            controller: insertAnimalController
                                                .selectedRace,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CustomIconButton(
                                          label: 'Cadastre',
                                          onPressed: () async {
                                            await MongoDataBase
                                                .retornaListaPets();
                                            String retorno =
                                                await insertAnimalController
                                                    .cadastrar(context);
                                            if (retorno != "") {
                                              mySnackBar(retorno, false);
                                            } else {
                                              mySnackBar(
                                                  'Cadastro feito com sucesso!',
                                                  true);
                                              insertAnimalController
                                                  .resetaCampos();
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

class PhotoContainer extends StatelessWidget {
  final VoidCallback onPressed;
  final File? image;
  bool pressed = false;

  PhotoContainer({required this.onPressed, required this.image});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            pressed = true;
          },
          child: Container(
            width: 130,
            height: 130,
            child: image != null
                ? ClipOval(
                    child: Image.file(
                      image!,
                      width: 130,
                      height: 130,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(
                    child: Container(
                    color: const Color.fromARGB(255, 100, 97, 97),
                  )),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 255, 72, 16),
              ),
              child: Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class TipoSexoButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String sexo;
  final int tipo;
  final RxInt selectedType;
  final Color cor;

  TipoSexoButton({
    required this.onPressed,
    required this.imagePath,
    required this.tipo,
    required this.selectedType,
    required this.sexo,
    required this.cor,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isSelected = selectedType.value == tipo;
      return Card(
        elevation: 15,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
          side: BorderSide(
            color: isSelected ? Colors.blue : Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
              color: cor, borderRadius: BorderRadius.all(Radius.circular(10))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 8, 0, 0),
            child: Column(
              children: [
                Image.asset(
                  imagePath,
                  width: 20,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}

class CustomDropdownButton extends StatelessWidget {
  final List<String> items;
  final RxString controller;

  CustomDropdownButton({required this.items, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
          width: 95,
          height: 40,
          child: DropdownButton<String>(
            isExpanded: true,
            padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
            borderRadius: BorderRadius.circular(15),
            value: controller.value,
            onChanged: (String? newValue) {
              if (newValue != null) {
                controller.value = newValue;
              }
            },
            elevation: 8,
            menuMaxHeight: 200,

            style: TextStyle(color: Colors.black), // Estilo do texto
            underline: Container(
              color: Colors.transparent,
            ),
            items: items.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontFamily: 'AsapCondensed-Bold',
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ));
  }
}

class TipoAnimalButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String tipo;
  final RxString selectedType;

  TipoAnimalButton({
    required this.onPressed,
    required this.imagePath,
    required this.tipo,
    required this.selectedType,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Obx(() {
        final isSelected = selectedType.value == tipo;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
            side: BorderSide(
              color: isSelected
                  ? Color.fromARGB(255, 255, 94, 0)
                  : Colors.transparent,
              width: 1.0,
            ),
          ),
          elevation: 8,
          child: Container(
            width: 41,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              image: DecorationImage(
                image: AssetImage('assets/card3.png'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: SizedBox(
                width: isSelected ? 35 : 30,
                height: isSelected ? 35 : 30,
                child: Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
