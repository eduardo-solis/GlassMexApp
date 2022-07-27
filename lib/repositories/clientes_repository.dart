import 'package:sqflite/sqflite.dart';
import '../models/clientes.dart';
import 'dart:async';

class ClientesRepository {
  late Database _database;

  ClientesRepository(Database pDatabase) {
    _database = pDatabase;
  }

  Future<List<Clientes>> getAll() async {
    List result =
        await _database.rawQuery("SELECT * FROM clientes ORDER BY idCliente");

    var lista = result
        .map((item) => Clientes(
            int.parse(item["idCliente"]),
            item["nombre"],
            item["primerApellido"],
            item["segundoApellido"],
            item["genero"],
            item["dia"],
            item["mes"],
            item["anio"],
            item["calle"],
            item["numero"],
            item["colonia"],
            item["cp"],
            item["ciudad"],
            item["estado"],
            item["correo"],
            item["correoRec"],
            item["contrasenia"],
            item["estatus"]))
        .toList();

    return lista;
  }

  Future<Clientes?> getClient(String correo, String contrasenia) async {
    var result = await _database.rawQuery(
        "SELECT * FROM clientes WHERE correo = ? AND contrasenia = ?",
        [correo, contrasenia]);

    if (result.isNotEmpty) {
      return Clientes.formMap(result.first);
    }

    return null;
  }

  Future<Clientes?> getClientById(String id) async {
    var result = await _database
        .rawQuery("SELECT * FROM clientes WHERE idCliente = ?", [id]);

    if (result.isNotEmpty) {
      return Clientes.formMap(result.first);
    }

    return null;
  }

  register(Clientes modelo) async {
    var parametros = modelo.mapForInsert();
    await _database.insert("clientes", parametros);
  }

  Future<int> update(Clientes modelo) async {
    // Actualización utilizando raw
    var count = await _database.rawUpdate(
        'UPDATE clientes SET calle = ?, numero = ?, colonia = ?, cp = ?, ciudad = ?, estado = ?, correo = ?, correoRec = ?, contrasenia = ? WHERE idCliente = ?',
        [
          modelo.calle,
          modelo.numero,
          modelo.colonia,
          modelo.cp,
          modelo.ciudad,
          modelo.estado,
          modelo.correo,
          modelo.correoRec,
          modelo.contrasenia,
          modelo.idCliente
        ]);
    return modelo.idCliente;
  }
}
