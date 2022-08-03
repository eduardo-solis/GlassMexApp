import 'package:flutter/material.dart';
import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/ventas_repository.dart';

class PayScreen extends StatefulWidget {
  final int idVenta;
  final double total;
  const PayScreen({Key? key, required this.idVenta, required this.total})
      : super(key: key);

  @override
  State<PayScreen> createState() => _PayScreenState();
}

class _PayScreenState extends State<PayScreen> {
  TextEditingController noTarjeta = TextEditingController();
  TextEditingController cvv = TextEditingController();
  TextEditingController vMes = TextEditingController();
  TextEditingController vAnio = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Inicializando la base de datos
  late Database _database;
  late VentasRepository _ventasRepository;

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    _ventasRepository = VentasRepository(_database);
  }

  pagar() {
    if (_formKey.currentState!.validate()) {
      _ventasRepository.pay(widget.idVenta);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Datos de la tarjeta",
          style: TextStyle(fontFamily: "Nunito", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: HexColor("01688c"),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
            child: Center(
          child: Container(
            padding: const EdgeInsets.all(20),
            margin: const EdgeInsets.all(10),
            child: Column(
              children: [
                TextFormField(
                  controller: noTarjeta,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "No. Tarjeta",
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty || value.length <= 15) {
                      return "Debe introducir un numero de tarjeta valido";
                    }
                    return null;
                  },
                ),
                TextFormField(
                  controller: cvv,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "CVV",
                    prefixIcon: Icon(Icons.numbers_outlined),
                  ),
                  validator: (value) {
                    if (value!.isEmpty ||
                        value.length <= 2 ||
                        value.length > 3) {
                      return "Debe introducir un cvv valido";
                    }
                    return null;
                  },
                ),
                Container(
                  margin: const EdgeInsets.all(15),
                  child: const Text(
                    "Vencimiento",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: vMes,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Mes",
                          prefixIcon: Icon(Icons.credit_card_outlined),
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length <= 1 ||
                              value.length >= 3) {
                            return "Debe introducir un mes valido";
                          }
                          return null;
                        },
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      child: const Text("/"),
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: vAnio,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: "Año",
                          prefixIcon: Icon(Icons.credit_card_outlined),
                        ),
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length <= 1 ||
                              value.length >= 3) {
                            return "Debe introducir un año valido";
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                const SizedBox(
                  height: 25,
                ),
                Text(
                  "Total a pagar: ${widget.total}",
                  style: const TextStyle(fontSize: 20),
                ),
                const SizedBox(
                  height: 25,
                ),
                ElevatedButton(
                    onPressed: pagar, child: const Text("Confirmar pago"))
              ],
            ),
          ),
        )),
      ),
    );
  }
}
