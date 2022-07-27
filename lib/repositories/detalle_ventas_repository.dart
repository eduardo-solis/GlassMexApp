import 'package:sqflite/sqflite.dart';
import '../models/detalle_ventas.dart';
import 'dart:async';

class DetalleVentasRepository {
  late Database _database;

  DetalleVentasRepository(Database pDatabase) {
    _database = pDatabase;
  }

  Future<List<DetalleVentas>> getAll() async {
    List result = await _database
        .rawQuery("SELECT * FROM detalle_ventas ORDER BY idDetalleVenta");

    var lista = result
        .map((item) => DetalleVentas(
            int.parse(item["idDetalleVenta"]),
            int.parse(item["idVenta"]),
            int.parse(item["idProducto"]),
            double.parse(item["precioUnitario"]),
            int.parse(item["cantidad"]),
            double.parse(item["subtotal"]),
            double.parse(item["cmcVendidos"]),
            item["forma"]))
        .toList();

    return lista;
  }

  Future<List<DetalleVentas>> getAllByVenta(int id) async {
    List result = await _database.rawQuery(
        "SELECT * FROM detalle_ventas idDetalleVenta WHERE idVenta = ?", [id]);
    //print(result.toString());
    var lista = result
        .map((item) => DetalleVentas(
            item["idDetalleVenta"],
            item["idVenta"],
            item["idProducto"],
            item["precioUnitario"],
            item["cantidad"],
            item["subtotal"],
            item["cmcVendidos"],
            item["forma"] ?? ""))
        .toList();

    return lista;
  }

  register(DetalleVentas modelo) async {
    var parametros = modelo.mapForInsert();
    await _database.insert("detalle_ventas", parametros);
  }

  Future<int> update(DetalleVentas modelo) async {
    // Actualización utilizando raw
    var count = await _database.rawUpdate(
        'UPDATE detalle_ventas SET precioUnitario = ?, cantidad = ?, subtotal = ?, cmcVendidos = ?, forma = ? WHERE idDetalleVenta = ?',
        [
          modelo.precioUnitario,
          modelo.cantidad,
          modelo.subtotal,
          modelo.cmcVendidos,
          modelo.forma,
          modelo.idDetalleVenta
        ]);
    print("Se actualizo el detalle");
    return modelo.idDetalleVenta;
  }

  deleteAllVenta(int id) async {
    var count = await _database
        .rawDelete('DELETE FROM detalle_ventas WHERE idVenta = ?', [id]);
  }

  delete(int id) async {
    var count = await _database
        .rawDelete('DELETE FROM detalle_ventas WHERE idDetalleVenta = ?', [id]);
  }
}
