// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

// esse arquivo exibe imagems na aba do feed e de pets de uma Ong. 


// coloquei dois parametros para o o widget, so uma foto do feed comum, e as informações do pet
class PicFeed extends StatelessWidget {
  dynamic image; // imagem que pega quando insere no app uma foto no feed.
  dynamic petInfo; //  informacoes de um pet
  int? tipo;

  PicFeed({this.image, this.petInfo});

  // Recupera a imagem do bd
  ImageProvider<Object> getImageProvider() {
    print('entrei aqui');
    // se vier um pet.
    if(petInfo != null){
      
      var imagem = petInfo['Tipo'] == '1' ? 'assets/exemplo1.png' : 'assets/exemplo2.png';
      petInfo['Imagem'] == null ? image = imagem: image = petInfo['Imagem'];
      
      if(petInfo['Imagem'] != null){
      
        return NetworkImage(petInfo['Imagem']);
      }
      else {
        return AssetImage(image);
      }
    }
    // se vier uma imagem de feed
    else{
      final Uint8List bytes = base64.decode(image);
      return MemoryImage(Uint8List.fromList(bytes));
    }  
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = getImageProvider();
    return 
    Container(
      width: MediaQuery.of(context).size.width / 3,
      height: MediaQuery.of(context).size.height / 6,
      decoration: BoxDecoration(
        image: DecorationImage(image: imageProvider,fit: BoxFit.cover),
        border: Border.all(color: Colors.black, width: 0.1),
      ),
    );
  }
}
