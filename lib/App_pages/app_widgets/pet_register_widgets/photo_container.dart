// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class PhotoContainer extends StatelessWidget {
  final VoidCallback onPressed;
  final File? image;
  bool pressed = false;
  dynamic imagembd;
  int? tipo;

  PhotoContainer({required this.onPressed, required this.image,this.imagembd, this.tipo});


  ImageProvider<Object> convertBase64ToImageProvider(String base64Image) {
    final Uint8List bytes = base64.decode(base64Image);
    return MemoryImage(Uint8List.fromList(bytes));
  }


  @override
  Widget build(BuildContext context) {
    final imageProvider = imagembd != null ? convertBase64ToImageProvider(imagembd):const AssetImage('assets/ame.png');
    return Stack(
      children: [
        GestureDetector(
          onLongPress: () {
            pressed = true;
          },
          child: SizedBox(
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
                    
                    decoration: BoxDecoration(
                color:const  Color.fromARGB(255, 255, 250, 248),
                borderRadius: BorderRadius.circular(50),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  )
                ),
                  )),
          ),
        ),
        tipo == 2 ?
        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: onPressed,
            child: Container(
              width: 40,
              height: 40,
              decoration:const  BoxDecoration(
                shape: BoxShape.circle,
                color: Color.fromARGB(255, 127, 125, 124),
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ):const SizedBox(),
      ],
    );
  }
}