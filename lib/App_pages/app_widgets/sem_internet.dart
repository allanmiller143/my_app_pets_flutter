import 'package:flutter/material.dart';

class SemInternetWidget extends StatelessWidget {
  const SemInternetWidget({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width *0.8,
        height: MediaQuery.of(context).size.width *0.6,
        decoration:const  BoxDecoration(
          image: DecorationImage(image: AssetImage('assets/semInternet.png'))
        ),
      ),
    );
  }
}