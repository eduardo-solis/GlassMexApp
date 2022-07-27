import 'package:sqflite/sqflite.dart';
import 'dart:async';

class DataBaseConnection {
  late Database _database;

  static initiateDataBase() async {
    await deleteDatabase("db_glassmex.db");
    return await openDatabase(
      "glassmex.db",
      version: 1 /*7*/,
      onCreate: (Database db, int version) {
        var sqlCreate = SqlCreateDatabase();
        db.execute(sqlCreate);
        print("Base de datos creada");
      }, /*onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion6();
      if (oldVersion == 1) {
        db.execute(sqlCreate);
      }
    }*/
    );
  }

  /*
  Una vez creada la base de datos se tiene que actualizar a la version 2
  añadiendo esta 
  onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion1();
      if (oldVersion == 1) {
        db.execute(sqlCreate);
      }
    }
  
  Depues a la version 3
  onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion2();
      if (oldVersion == 2) {
        db.execute(sqlCreate);
      }
    }
  
  Depues a la version 4
  onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion3();
      if (oldVersion == 3) {
        db.execute(sqlCreate);
      }
    }

    Depues a la version 5
  onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion4();
      if (oldVersion == 4) {
        db.execute(sqlCreate);
      }
    }

    Depues a la version 6
  onUpgrade: (db, oldVersion, newVersion) {
      print("Actualizando de la versión $oldVersion a la $newVersion");
      var sqlCreate = SqlUpgradeVersion5();
      if (oldVersion == 5) {
        db.execute(sqlCreate);
      }
    }
  */

  static String SqlCreateDatabase() {
    var sqlUsuarios =
        "CREATE TABLE IF NOT EXISTS clientes(idCliente INTEGER PRIMARY KEY,nombre TEXT,primerApellido TEXT,segundoApellido TEXT,genero TEXT,dia TEXT,mes TEXT,anio TEXT,calle TEXT,numero TEXT,colonia TEXT,cp TEXT,ciudad TEXT,estado TEXT,telefono TEXT,correo TEXT,correoRec TEXT,contrasenia TEXT, estatus INTEGER);";
    var sqlProductos =
        "CREATE TABLE IF NOT EXISTS productos(idProducto INTEGER PRIMARY KEY,nombre TEXT,descripcion TEXT,grosor TEXT,img TEXT,precioCompra REAL);";
    var sqlVentas =
        "CREATE TABLE IF NOT EXISTS ventas(idVenta INTEGER PRIMARY KEY,fechaVenta TEXT,fechaEntrega TEXT,idCliente INTEGER,total REAL,estatus INTEGER);";
    var sqlDetalleVentas =
        "CREATE TABLE IF NOT EXISTS detalle_ventas(idDetalleVenta INTEGER PRIMARY KEY,idVenta INTEGER,idProducto INTEGER,precioUnitario REAL,cantidad INTEGER,subtotal REAL,cmcVendidos REAL);";

    var sqlCreate = sqlUsuarios + sqlProductos + sqlVentas + sqlDetalleVentas;
    return sqlCreate;
  }

  static String SqlUpgradeVersion1() {
    var sqlUsuarios =
        "CREATE TABLE IF NOT EXISTS clientes(idCliente INTEGER PRIMARY KEY,nombre TEXT,primerApellido TEXT,segundoApellido TEXT,genero TEXT,dia TEXT,mes TEXT,anio TEXT,calle TEXT,numero TEXT,colonia TEXT,cp TEXT,ciudad TEXT,estado TEXT,telefono TEXT,correo TEXT,correoRec TEXT,contrasenia TEXT, estatus INTEGER);";
    return sqlUsuarios;
  }

  static String SqlUpgradeVersion2() {
    var sqlProductos =
        "CREATE TABLE IF NOT EXISTS productos(idProducto INTEGER PRIMARY KEY,nombre TEXT,descripcion TEXT,grosor TEXT,img TEXT,precioCompra REAL);";

    var sqlCreate = sqlProductos;
    return sqlCreate;
  }

  static String SqlUpgradeVersion3() {
    var sqlVentas =
        "CREATE TABLE IF NOT EXISTS ventas(idVenta INTEGER PRIMARY KEY,fechaVenta TEXT,fechaEntrega TEXT,idCliente INTEGER,total REAL,estatus INTEGER);";

    var sqlCreate = sqlVentas;
    return sqlCreate;
  }

  static String SqlUpgradeVersion4() {
    var sqlDetalleVentas =
        "CREATE TABLE IF NOT EXISTS detalle_ventas(idDetalleVenta INTEGER PRIMARY KEY,idVenta INTEGER,idProducto INTEGER,precioUnitario REAL,cantidad INTEGER,subtotal REAL,cmcVendidos REAL);";
    return sqlDetalleVentas;
  }

  static String SqlUpgradeVersion5() {
    var sqlCreate = "ALTER TABLE detalle_ventas ADD COLUMN forma TEXT;";
    return sqlCreate;
  }

  close() {
    _database.close();
  }
}
