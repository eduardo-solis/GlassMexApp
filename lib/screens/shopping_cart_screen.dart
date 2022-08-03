import 'package:flutter/material.dart';
import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/models/detalle_ventas.dart';
import 'package:glassmex/repositories/detalle_ventas_repository.dart';
import 'package:glassmex/repositories/ventas_repository.dart';
import 'package:glassmex/screens/pay_screen.dart';
import 'package:sqflite/sqflite.dart';

import '../helpers/hexcolor.dart';
import '../widgets/shopping_cart_widgets/custom_item_detalle.dart';

class ShoppingCartScreen extends StatefulWidget {
  const ShoppingCartScreen({Key? key, this.idUser}) : super(key: key);
  final int? idUser;

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  late Database _database;
  late VentasRepository ventasRepository;
  late DetalleVentasRepository detalleRepository;
  List<DetalleVentas> _detalles = List.empty();
  late int idVenta = 0;
  late double total = 0;
  bool activarBoton = false;

  ButtonStyle estiloBotonMas = ElevatedButton.styleFrom(primary: Colors.green);
  ButtonStyle estiloBotonMenos =
      ElevatedButton.styleFrom(primary: Colors.amber);
  ButtonStyle estiloBotonCancelar =
      ElevatedButton.styleFrom(primary: Colors.red);

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    ventasRepository = VentasRepository(_database);
    detalleRepository = DetalleVentasRepository(_database);
    refresGrid();
  }

  refresGrid() async {
    await ventasRepository
        .getVentaAbiertaByClient(widget.idUser!)
        .then((data) async {
      if (data != null) {
        idVenta = data.idVenta;
        total = double.parse((data.total).toStringAsFixed(2));
        _detalles = await detalleRepository.getAllByVenta(data.idVenta);
        activarBoton = true;
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
            "No se ha añadido nada al carrito de compras",
            style: TextStyle(color: Colors.black),
          ),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.amber,
        ));
        activarBoton = false;
        setState(() {});
      }
    });
  }

  pagar() {
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return PayScreen(
        idVenta: idVenta,
        total: total,
      );
    }));
  }

  cambio(int i, DetalleVentas dv) {
    if (i == 1) {
      masUno(dv);
    } else {
      if (i == 2) {
        menosUno(dv);
      } else {
        eliminar(dv);
      }
    }
  }

  Future<void> masUno(DetalleVentas dv) async {
    int newCantidad = dv.cantidad + 1;
    double newSubtotal = dv.precioUnitario * newCantidad;
    double newMedida = (dv.cmcVendidos / dv.cantidad) * newCantidad;

    await ventasRepository.getVenta(dv.idVenta).then((data) async {
      if (data != null) {
        double oldTotal = data.total;
        double newTotal = oldTotal - dv.subtotal + newSubtotal;
        data.total = newTotal;

        await ventasRepository.updateTotal(data.idVenta, data.total);
        dv.cantidad = newCantidad;
        dv.subtotal = newSubtotal;
        dv.cmcVendidos = newMedida;
        await detalleRepository.update(dv);
      }
    });
  }

  Future<void> menosUno(DetalleVentas dv) async {
    int newCantidad = dv.cantidad - 1;
    double newSubtotal = dv.precioUnitario * newCantidad;
    double newMedida = (dv.cmcVendidos / dv.cantidad) * newCantidad;

    await ventasRepository.getVenta(dv.idVenta).then((data) async {
      if (data != null) {
        double oldTotal = data.total;
        double newTotal = oldTotal - dv.subtotal + newSubtotal;
        data.total = newTotal;

        await ventasRepository.updateTotal(data.idVenta, data.total);
        dv.cantidad = newCantidad;
        dv.subtotal = newSubtotal;
        dv.cmcVendidos = newMedida;
        await detalleRepository.update(dv);
      }
    });
  }

  Future<void> eliminar(DetalleVentas dv) async {
    await ventasRepository.getVenta(dv.idVenta).then((data) async {
      if (data != null) {
        double oldTotal = data.total;
        double newTotal = oldTotal - dv.subtotal;
        data.total = newTotal;

        await ventasRepository.updateTotal(data.idVenta, data.total);
        await detalleRepository.delete(dv.idDetalleVenta);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            "Carrito de compra",
            style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          backgroundColor: HexColor("01688c")),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(15),
              padding: const EdgeInsets.all(15),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        "Total: $total",
                        style: const TextStyle(fontSize: 30),
                      )
                    ],
                  ),
                ],
              ),
            ),
            Column(
              children: List.generate(_detalles.length, (index) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      flex: 3,
                      child: CustomItemDetalle(
                          db: _database,
                          idVenta: idVenta,
                          idDetalleVenta: _detalles[index].idDetalleVenta,
                          idProducto: _detalles[index].idProducto,
                          precioUnitario: double.parse(
                              (_detalles[index].precioUnitario)
                                  .toStringAsFixed(2)),
                          cantidad: _detalles[index].cantidad,
                          subtotal: double.parse(
                              (_detalles[index].subtotal).toStringAsFixed(2)),
                          forma: _detalles[index].forma),
                    ),
                    Expanded(
                        child: Column(
                      children: [
                        ElevatedButton(
                          style: _detalles[index].cantidad >= 2
                              ? estiloBotonMenos
                              : estiloBotonCancelar,
                          onPressed: () {
                            if (_detalles[index].cantidad >= 2) {
                              cambio(2, _detalles[index]);
                              setState(() {
                                initVariables();
                              });
                            } else {
                              cambio(3, _detalles[index]);
                              setState(() {
                                initVariables();
                              });
                            }
                          },
                          child: Icon(_detalles[index].cantidad >= 2
                              ? Icons.exposure_minus_1_outlined
                              : Icons.delete_outline),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              cambio(1, _detalles[index]);
                              setState(() {
                                initVariables();
                              });
                            },
                            style: estiloBotonMas,
                            child: const Icon(Icons.exposure_plus_1_outlined))
                      ],
                    ))
                  ],
                );
              }),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (activarBoton) {
            pagar();
          }
        },
        splashColor: Colors.green,
        label: const Text(
          "Pagar",
          style: TextStyle(fontSize: 18),
        ),
        icon: const Icon(Icons.monetization_on_outlined),
      ),
    );
  }
}
