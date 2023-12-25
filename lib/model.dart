import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPageController extends GetxController {
  Future<String> func() async {
    return 'allan';
  }

 
}

// ignore: must_be_immutable
class SettingsPage extends StatelessWidget {
  SettingsPage({super.key});
  var settingsPageController = Get.put(SettingsPageController());

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GetBuilder<SettingsPageController>(
        init: SettingsPageController(),
        builder: (_) {
          return Scaffold(
            body: FutureBuilder(
              future: settingsPageController.func(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    return const Center(
                      child: Column(
                        
                      ),
                    );
                  } else {
                    return const Text('Nenhum pet disponível');
                  }
                } else if (snapshot.hasError) {
                  return Text(
                      'Erro ao carregar a lista de pets: ${snapshot.error}');
                } else {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Color.fromARGB(255, 253, 72, 0),
                    ),
                  );
                }
              },
            ),
          );
        },
      ),
    );
  }
}
