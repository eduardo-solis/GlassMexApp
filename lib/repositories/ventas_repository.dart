import 'package:sqflite/sqflite.dart';
import '../models/ventas.dart';
import 'dart:async';

class VentasRepository {
  late Database _database;

  VentasRepository(Database pDatabase) {
    _database = pDatabase;
  }

  Future<List<Ventas>> getAll() async {
    List result =
        await _database.rawQuery("SELECT * FROM ventas ORDER BY idVenta");

    var lista = result
        .map((item) => Ventas(
            int.parse(item["idVenta"].toString()),
            item["fechaVenta"],
            item["fechaEntrega"],
            int.parse(item["idCliente"]),
            double.parse(item["total"]),
            int.parse(item["estatus"])))
        .toList();

    return lista;
  }

  Future<Ventas?> getVenta(int id) async {
    var result = await _database
        .rawQuery("SELECT * FROM ventas WHERE idVenta = ?", [id]);

    if (result.isNotEmpty) {
      return Ventas.fromMap(result.first);
    }
    return null;
  }

  Future<Ventas?> getVentaAbiertaByClient(int id) async {
    var result = await _database.rawQuery(
        "SELECT * FROM ventas WHERE idCliente = ? AND estatus = 1", [id]);

    if (result.isNotEmpty) {
      return Ventas.fromMap(result.first);
    }
    return null;
  }

  Future<List<Ventas>> getVentaCerradaByClient(int id) async {
    List result = await _database.rawQuery(
        "SELECT * FROM ventas WHERE idCliente = ? AND estatus = 2", [id]);
    print(result);
    var lista = result
        .map((item) => Ventas(
            int.parse(item["idVenta"].toString()),
            item["fechaVenta"],
            item["fechaEntrega"],
            item["idCliente"],
            item["total"],
            item["estatus"]))
        .toList();

    return lista;
  }

  register(Ventas modelo) async {
    var parametros = modelo.mapForInsert();
    await _database.insert("ventas", parametros);
  }

  update(Ventas modelo) async {
    var count = await _database.rawUpdate(
        'UPDATE ventas SET total = ? WHERE idVenta = ?',
        [modelo.total, modelo.idVenta]);
  }

  updateTotal(int idVenta, double total) async {
    var count = await _database.rawUpdate(
        'UPDATE ventas SET total = ? WHERE idVenta = ?', [total, idVenta]);
  }

  pay(int id) async {
    var count = await _database
        .rawUpdate('UPDATE ventas SET estatus = ? WHERE idVenta = ?', [2, id]);
  }

  delete(int id) async {
    var count =
        await _database.rawDelete('DELETE FROM ventas WHERE idVenta = ?', [id]);
  }
}
