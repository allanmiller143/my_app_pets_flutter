// ignore_for_file: must_be_immutable, use_key_in_widget_constructors

import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
class FeedDetail extends StatelessWidget {


  dynamic imagembd; // imagem que puxa do banco de dados
  int? tipo;
  String? tipoPet;

  FeedDetail({required this.imagembd, this.tipo = 2,this.tipoPet = '1'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        
        image: DecorationImage(
          image: NetworkImage(imagembd),
          fit: BoxFit.cover,
          
        ),
      ),
      
    );
  }
}
