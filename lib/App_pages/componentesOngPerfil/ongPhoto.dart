// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class OngPhoto extends StatelessWidget {
  final VoidCallback onPressed;
  final File? image; // imagem que pega quando insere no app
  dynamic imagembd; // imsgem que puxa do banco de dados
  int? tipo;

  OngPhoto({required this.onPressed, required this.image, this.imagembd, this.tipo = 2});

  // Recupera a imagem do bd
  ImageProvider<Object> getImageProvider() {
    if (image != null) {
      return FileImage(image!);
    } else if (imagembd != null) {
      final Uint8List bytes = base64.decode(imagembd);
      return MemoryImage(Uint8List.fromList(bytes));
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
        child: Stack(
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
                  child: Icon(Icons.camera_alt, size: 16, color: const Color.fromARGB(255, 255, 255, 255)),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
