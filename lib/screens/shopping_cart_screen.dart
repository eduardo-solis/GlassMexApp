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

  ButtonStyle estiloBotonMas = ElevatedButton.styleFrom(primary: Colors.blue);
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
        if (_detalles.isNotEmpty) {
          activarBoton = true;
        }
        setState(() {});
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "No se ha añadido nada al carrito de compras",
              style: TextStyle(color: Colors.black),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.amber,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )));
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

  cambiarCantidad(DetalleVentas dv, TextEditingController conCantidad) async {
    int newCantidad = int.parse(conCantidad.text);
    int oldCantidad = dv.cantidad;

    double newSubtotal = dv.precioUnitario * newCantidad;
    double newMedida = (dv.cmcVendidos / dv.cantidad) * newCantidad;

    if (newCantidad != oldCantidad) {
      await ventasRepository.getVenta(dv.idVenta).then((data) async {
        double oldTotal = data!.total;
        double newTotal = oldTotal - dv.subtotal + newSubtotal;
        data.total = newTotal;

        await ventasRepository.updateTotal(data.idVenta, data.total);

        dv.cantidad = newCantidad;
        dv.subtotal = newSubtotal;
        dv.cmcVendidos = newMedida;
        await detalleRepository.update(dv);
      }).whenComplete(() {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Se ha actualizado el producto",
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.green,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
      }).onError((error, stackTrace) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "Se ha producido un error al intentar actualizar",
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
          elevation: 0,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "No se ha actualizado ya que es la misma cantidad",
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.amber,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));
    }
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
    }).whenComplete(() {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Se ha eliminado el producto",
        ),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.amber,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ));

      initVariables();
      setState(() {});
    });
  }

  Future<void> editDialog(DetalleVentas dv) async {
    final conCantidad = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text("Cambiar cantidad"),
            content: const Text("Ingrese el valor de la cantidad deseada."),
            actions: [
              TextFormField(
                controller: conCantidad,
                keyboardType: TextInputType.number,
                validator: (value) {
                  String valor = value!.trim();
                  if (valor.isEmpty ||
                      valor.contains(".") ||
                      valor.contains(",") ||
                      valor.contains("-") ||
                      valor == "0") {
                    return "Es necesario ingresar un numero entero";
                  }
                },
                decoration: const InputDecoration(label: Text("Cantidad")),
              ),
              const SizedBox(
                height: 15,
              ),
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      cambiarCantidad(dv, conCantidad);
                      Navigator.of(context).pop();
                      initVariables();
                      setState(() {});
                    }
                  },
                  child: const Text("Cambiar"))
            ],
          ),
        );
      },
    );
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
                        "Total: \n\$$total MXN",
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
                          style: estiloBotonCancelar,
                          onPressed: () {
                            eliminar(_detalles[index]);
                          },
                          child: const Icon(Icons.delete_outline),
                        ),
                        ElevatedButton(
                            onPressed: () {
                              editDialog(_detalles[index]);
                            },
                            style: estiloBotonMas,
                            child: const Icon(Icons.edit))
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
          if (_detalles.isNotEmpty) {
            pagar();
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                "No se tiene ningun producto en el carrito",
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.amber,
              elevation: 0,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ));
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
