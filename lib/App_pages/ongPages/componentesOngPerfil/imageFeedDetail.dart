// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
class FeedDetail extends StatelessWidget {


  dynamic imagembd; // imsagem que puxa do banco de dados
  int? tipo;
  String? tipoPet;

  FeedDetail({required this.imagembd, this.tipo = 2,this.tipoPet = '1'});

  ImageProvider<Object> getImageProvider() {
    if(imagembd == null){
      // verificar se é cachorro ou gato e exibir a imagem certa 
      if(tipoPet == '1'){
        return const AssetImage('assets/exemplo1.png');

      }else{
        return const AssetImage('assets/exemplo2.png');
      }
      

    }
      final Uint8List bytes = base64.decode(imagembd);
      return MemoryImage(Uint8List.fromList(bytes));
  }

  @override
  Widget build(BuildContext context) {
    final imageProvider = getImageProvider();
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        
        image: DecorationImage(
          image: imageProvider,
          fit: BoxFit.cover,
          
        ),
      ),
      
    );
  }
}
