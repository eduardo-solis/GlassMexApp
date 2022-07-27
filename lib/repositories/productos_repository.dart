import 'package:sqflite/sqflite.dart';
import '../models/productos.dart';
import 'dart:async';

class ProductosRepository {
  late Database _database;

  ProductosRepository(Database pDatabase) {
    _database = pDatabase;
  }

  Future<List<Productos>> getAll() async {
    List result =
        await _database.rawQuery("SELECT * FROM productos ORDER BY idProducto");

    var lista = result
        .map((item) => Productos(
            item["idProducto"],
            item["nombre"],
            item["grosor"],
            item["img"],
            item["descripcion"],
            item["precioCompra"]))
        .toList();

    return lista;
  }

  Future<Productos?> getProductById(int id) async {
    var result = await _database
        .rawQuery("SELECT * FROM productos WHERE idProducto = ?", [id]);

    if (result.isNotEmpty) {
      return Productos.forMap(result.first);
    }
    return null;
  }

  Future<Productos?> getProduct(String nombre, String grosor) async {
    var result = await _database.rawQuery(
        "SELECT * FROM productos WHERE nombre = ? AND grosor = ?",
        [nombre, grosor]);

    if (result.isNotEmpty) {
      return Productos.forMap(result.first);
    }
    return null;
  }

  register(Productos modelo) async {
    var parametros = modelo.mapForInsert();
    await _database.insert("productos", parametros);
  }
}
