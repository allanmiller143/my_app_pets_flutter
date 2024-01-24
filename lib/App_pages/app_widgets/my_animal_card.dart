// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:replica_google_classroom/controller/userController.dart';

class AnimalCard extends StatelessWidget {
  final VoidCallback onPressed;
  final Map<String, dynamic> pet;
  final RxBool preferido = false.obs;
  final MeuControllerGlobal meuControllerGlobal;

  AnimalCard({
    required this.onPressed,
    required this.pet,
    required this.meuControllerGlobal,
  });

  void verificaFavorito() {
    if (meuControllerGlobal.usuario['Pets preferidos'].contains(pet)) {
      preferido.value = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    verificaFavorito();

    return Obx(
      () => GestureDetector(
        onTap: onPressed,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 8,
          child: Container(
            width: 160,
            height: 225,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 250, 248),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 6, 0, 0),
                  child: Container(
                    width: 150,
                    height: 120,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(15),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(pet['Imagem']),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            pet['Nome animal'],
                            style: const TextStyle(
                              fontSize: 22,
                              fontFamily: 'AsapCondensed-Bold',
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ),
                        ],
                      ),
                      Icon(
                        pet['Sexo'] != 'Fêmea'? Icons.male: Icons.female,size: 22,
                        color: pet['Sexo'] == 'Fêmea'? const Color.fromARGB(255, 255, 72, 0) : const Color.fromARGB(255, 17, 61, 94),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['Idade'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'AsapCondensed-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        pet['Raça'],
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'AsapCondensed-Medium',
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        preferido.value = !preferido.value;
                        //MongoDataBase.favoritaPet(meuControllerGlobal.usuario['E-mail'], preferido.value, pet['id']);
                        //meuControllerGlobal.favoritaPet(pet['id'],preferido.value);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(0, 0, 5, 0),
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 255, 255, 255),
                            borderRadius: const BorderRadius.all(
                              Radius.circular(15),
                            ),
                            image: DecorationImage(
                              image: preferido.value
                                  ? const AssetImage('assets/ame.png')
                                  : const AssetImage('assets/ame2.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
