import 'package:flutter/material.dart';

class CustomCardHomePage extends StatelessWidget {
  final VoidCallback onPressed;
  final String imagePath;
  final String text;
  final Color containerColor;
  final Color textColor;
  final Color backgroundImageColor;

  CustomCardHomePage({
    required this.onPressed,
    required this.imagePath,
    required this.text,
    this.containerColor = const Color.fromARGB(255, 255, 255, 255),
    this.textColor = Colors.black,
    this.backgroundImageColor = const Color.fromARGB(255, 255, 81, 0),
  });


  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 20,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Container(
          width: 60,
          height: 95,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(30)),
            color: containerColor,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(3, 5, 3, 5),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: backgroundImageColor,
                    borderRadius: BorderRadius.circular(50),
                    image: DecorationImage(
                      image: AssetImage(imagePath),
                    ),
                  ),
                ),
              ),
              Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 13,
                  fontFamily: 'AsapCondensed-Light',
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}