// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';

class OngPhoto extends StatelessWidget {
  final VoidCallback onPressed;
  final File? image; // imagem que pega quando insere no app
  dynamic imagembd; // imsgem que puxa do banco de dados
  bool args;

  OngPhoto({required this.onPressed, required this.image, this.imagembd, required this.args });

  // Recupera a imagem do bd
  ImageProvider<Object> getImageProvider() {
    if (image != null) {
      return FileImage(image!);
    } else if (imagembd != '') {
      return NetworkImage(imagembd);
    } else {
      return const AssetImage('assets/fundo.png'); // um imagem padrao 
    }
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = getImageProvider();

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.35,
        height: MediaQuery.of(context).size.height * 0.25,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(15)),
        ),
        child: 
        args == false ?
        Stack(
          children: [
            Positioned(
              bottom: 0,
              right: 0,
              child: GestureDetector(
                onTap: onPressed,
                child: Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color.fromARGB(255, 255, 94, 7),
                  ),
                  child: Icon(Icons.add, size: 16, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            )
          ],
        ):const SizedBox(),
      ),
    );
  }
}
