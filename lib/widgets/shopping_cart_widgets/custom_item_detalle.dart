import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../../repositories/productos_repository.dart';

class CustomItemDetalle extends StatefulWidget {
  final Database db;
  final int idVenta;
  final int idDetalleVenta;
  final int idProducto;
  final double precioUnitario;
  final int cantidad;
  final double subtotal;
  final String forma;
  const CustomItemDetalle({
    Key? key,
    required this.idVenta,
    required this.idDetalleVenta,
    required this.db,
    required this.idProducto,
    required this.precioUnitario,
    required this.cantidad,
    required this.subtotal,
    required this.forma,
  }) : super(key: key);

  @override
  State<CustomItemDetalle> createState() => _CustomItemDetalleState();
}

class _CustomItemDetalleState extends State<CustomItemDetalle> {
  late ProductosRepository _productosRepository;
  String nombre = "";
  String forma = "";

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _productosRepository = ProductosRepository(widget.db);
    await _productosRepository.getProductById(widget.idProducto).then((data) {
      nombre = "${data!.nombre} ${data.grosor} mm";
    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 1)],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: const EdgeInsets.all(15),
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(nombre),
              Text("Forma: ${widget.forma}"),
              Text("Precio unitario ${widget.precioUnitario}"),
              Text("Cantidad ${widget.cantidad}"),
              Text("Subtotal ${widget.subtotal}")
            ],
          )
        ],
      ),
    );
  }
}
