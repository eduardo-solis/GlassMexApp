import 'package:flutter/material.dart';
import 'package:glassmex/models/detalle_ventas.dart';
import 'package:glassmex/models/productos.dart';
import 'package:glassmex/repositories/detalle_ventas_repository.dart';
import 'package:glassmex/repositories/productos_repository.dart';

import 'package:sqflite/sqflite.dart';

import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/repositories/ventas_repository.dart';
import '../models/ventas.dart';

class MyPurchasesScreen extends StatefulWidget {
  final int idUser;
  const MyPurchasesScreen({Key? key, required this.idUser}) : super(key: key);

  @override
  State<MyPurchasesScreen> createState() => _MyPurchasesScreenState();
}

class _MyPurchasesScreenState extends State<MyPurchasesScreen> {
  late Database _database;
  late VentasRepository _VentasRepository;
  List<Ventas> _ventas = List.empty();
  bool mostrarDetalle = false;

  @override
  void initState() {
    initVariables();
    //refreshGrid();
    super.initState();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    //print(_database);
    _VentasRepository = VentasRepository(_database);
    refreshGrid();
  }

  refreshGrid() async {
    _ventas = await _VentasRepository.getVentaCerradaByClient(widget.idUser);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Mis compras",
          style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        centerTitle: true,
        backgroundColor: HexColor("01688c"),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: List.generate(_ventas.length, (index) {
          return Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  color: Colors.white,
                  boxShadow: <BoxShadow>[
                    BoxShadow(color: Colors.black, blurRadius: 1)
                  ]),
              child: Column(
                children: [
                  Text("No. Venta: ${_ventas[index].idVenta}"),
                  Text(
                      "No. Total: ${double.parse((_ventas[index].total).toStringAsFixed(2))}"),
                  Text("Fecha de compra: ${_ventas[index].fechaVenta}"),
                  Text("Fecha de entrega: ${_ventas[index].fechaEntrega}"),
                  CustomDetalle(
                    idVenta: _ventas[index].idVenta,
                    db: _database,
                  )
                ],
              ));
        }),
      )),
    );
  }
}

class CustomDetalle extends StatefulWidget {
  final int idVenta;
  final Database db;
  const CustomDetalle({
    Key? key,
    required this.idVenta,
    required this.db,
  }) : super(key: key);

  @override
  State<CustomDetalle> createState() => _CustomDetalleState();
}

class _CustomDetalleState extends State<CustomDetalle> {
  late DetalleVentasRepository _detalleVentasRepository;
  List<DetalleVentas> _detalle = List.empty();
  bool mostrar = false;

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _detalleVentasRepository = DetalleVentasRepository(widget.db);
    refreshGrid();
  }

  refreshGrid() async {
    _detalle = await _detalleVentasRepository.getAllByVenta(widget.idVenta);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
            onPressed: () {
              mostrar = !mostrar;
              setState(() {});
            },
            child: Text(mostrar ? "Ocultar" : "Mostrar")),
        Column(
            children: List.generate(_detalle.length, (index) {
          return Container(
            width: double.infinity,
            child: Visibility(
              visible: mostrar,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(),
                      Text("Forma: ${_detalle[index].forma}"),
                      Text(
                          "Precio unitario: ${double.parse((_detalle[index].precioUnitario).toStringAsFixed(2))}"),
                      Text("Cantidad: ${_detalle[index].cantidad}"),
                      Text(
                          "Subtotal: ${double.parse((_detalle[index].subtotal).toStringAsFixed(2))}")
                    ],
                  ),
                ],
              ),
            ),
          );
        })),
      ],
    );
  }
}
