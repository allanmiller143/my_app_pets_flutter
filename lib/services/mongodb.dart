// ignore_for_file: avoid_print, unused_catch_clause

import 'package:mongo_dart/mongo_dart.dart';

class MongoDataBase {
  static Db? db;
  static late DbCollection collection;
  static Future<void> connect() async {
    try {
      db = await Db.create(
          "mongodb+srv://allanmiller:32172528@cluster0.d8cxwn6.mongodb.net/");
      await db!.open();
      collection = db!.collection('users');
      print('Conexão com o MongoDB estabelecida com sucesso.');
    } catch (e) {
      print('Erro ao conectar ao MongoDB: $e');
      // Você pode lidar com o erro de conexão aqui.
    }
  }

  static Future<void> insereUser(
    nome,
    email,
    password,
  ) async {
    await collection.insertOne({
      'userName': nome,
      'email': email,
      'password': password,
      'data': false,
      'petList': []
    });
  }

  static Future<bool> verificaUser(email) async {
    if (email != null && email != '') {
      var consulta = where.eq('email', email);
      var user = await collection.findOne(consulta);
      if (user != null) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  static Future<bool> verificaUserESenha(email, senha) async {
    if (email != null && email != '') {
      var consultaEmail = where.eq('email', email);
      var user = await collection.findOne(consultaEmail);
      if (user != null && user['password'] == senha) {
        return true; // Email e senha correspondem a um registro no banco de dados.
      } else {
        return false; // Email ou senha estão incorretos ou não correspondem.
      }
    }
    return false;
  }

  static Future<String> retornaNome(email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    return user!['userName'].toString();
  }

  static Future<void> trocaSenha(email, novaSenha) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);

    var updatedUser = user;
    updatedUser!['password'] =
        novaSenha; // Substitua 'password' pelo campo apropriado em seu documento de usuário.
    await collection.update(consultaEmail, updatedUser);
  }

  static Future<void> insertUserData(
      String email, Map<String, dynamic> newData) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);

    if (user != null) {
      // Atualize o documento com as novas informações
      newData.forEach((key, value) {
        user[key] = value;
      });
      user['data'] = true;
      await collection.update(consultaEmail, user);
    } else {
      print('nao achei!');
    }
  }

  static Future<bool> verificaUserData(String email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    if (user!['data'] == false) {
      return false;
    }
    return true;
  }

  static Future<void> inserePet(
    String ongCnpj,
    Map<String, dynamic> petData,
  ) async {
    try {
      // Encontre a Ong com base no CNPJ fornecido
      var consultaOng = where.eq('cnpj', ongCnpj);
      var ong = await collection.findOne(consultaOng);

      if (ong != null) {
        // Obtenha a lista atual de pets da Ong
        List<dynamic> petList = ong['petList'] ?? [];

        // Adicione o pet inteiro à lista de pets
        petList.add(petData);

        // Atualize a lista de pets da Ong no documento
        ong['petList'] = petList;

        // Atualize o documento da Ong na coleção
        await collection.update(consultaOng, ong);

        print('Pet inserido com sucesso na lista de pets da Ong.');
      } else {
        print('Ong não encontrada com o CNPJ fornecido.');
        // Lide com a situação onde a Ong não é encontrada com o CNPJ.
      }
    } catch (e) {
      print('Erro ao inserir o pet na lista de pets da Ong: $e');
      // Você pode lidar com o erro aqui.
    }
  }

  static Future<List<Map<String, dynamic>>> retornaListaPets() async {
  final ongs = await collection.find(where.eq('Tipo', '2')).toList();
  final List<Map<String, dynamic>> allPets = [];

  for (var ong in ongs) {
    final petList = ong['petList'] as List<dynamic>;
    String endereco = '${ong['cidade']}, ${ong['estado']}';

    for (var pet in petList) {
      Map<String, dynamic> petInfo = {
        'nomeOng': ong['nomeOng'],
        'email': ong['email'],
        'localizacao': endereco,
        'tipo': pet['tipo'],
        'nome': pet['nome'],
        'idade': pet['idade'],
        'sexo': pet['sexo'],
        'porte': pet['porte'],
        'raca': pet['raca'],
        'imagem': pet['imagem'],
      };

      allPets.add(petInfo);
    }
  }

  for (var p in allPets) {
    print(p['nome']);
  }

  return allPets;
}

}
