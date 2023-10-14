// ignore_for_file: avoid_print, unused_catch_clause

import 'package:mongo_dart/mongo_dart.dart';


class MongoDataBase {
  //Isso define uma classe chamada MongoDataBase.
  static Db?db; 
      // Esta linha declara uma variável estática db do tipo Db (a partir da biblioteca mongo_dart) que pode ser nula (?). O uso do static significa que essa variável pertence à classe em vez de a uma instância específica. Essa variável será usada para armazenar a conexão com o banco de dados MongoDB.

  static late DbCollection collection;
  //Esta linha declara uma variável estática collection do tipo DbCollection (também da biblioteca mongo_dart) usando a palavra-chave late. O uso de late indica que essa variável será inicializada posteriormente no código, antes de ser usada. Essa variável será usada para acessar uma coleção específica no banco de dados.

  static Future<void> connect() async {
    try {
      db = await Db.create("mongodb+srv://allanmiller:32172528@cluster0.d8cxwn6.mongodb.net/");
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
      'data': false
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
    } else {}
  }

  static Future<bool> verificaUserData(String email) async {
    var consultaEmail = where.eq('email', email);
    var user = await collection.findOne(consultaEmail);
    if (user!['data'] == false) {
      return false;
    }
    return true; 
  }
}
