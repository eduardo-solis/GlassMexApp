import 'dart:math';

import 'package:flutter/material.dart';
import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/models/clientes.dart';
import 'package:glassmex/models/detalle_ventas.dart';
import 'package:glassmex/models/productos.dart';
import 'package:glassmex/models/ventas.dart';
import 'package:glassmex/repositories/clientes_repository.dart';
import 'package:glassmex/repositories/detalle_ventas_repository.dart';
import 'package:glassmex/repositories/ventas_repository.dart';
import 'package:glassmex/screens/login_screen.dart';
import 'package:glassmex/screens/register_screen.dart';
import 'package:glassmex/widgets/product_widgets/custom_form_cc.dart';
import 'package:glassmex/widgets/product_widgets/custom_form_ro.dart';
import 'package:glassmex/widgets/product_widgets/custom_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

import '../repositories/productos_repository.dart';

class ProductScreen extends StatefulWidget {
  final String nombre;
  final String grosor;
  final String img;

  const ProductScreen(
      {Key? key, required this.nombre, required this.grosor, required this.img})
      : super(key: key);

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late Database _database;
  late ProductosRepository productosRepository;
  late VentasRepository _ventasRepository;
  late DetalleVentasRepository _detalleVentasRepository;
  late ClientesRepository _clientesRepository;
  int? idCliente = 0;
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    productosRepository = ProductosRepository(_database);
    _ventasRepository = VentasRepository(_database);
    _detalleVentasRepository = DetalleVentasRepository(_database);
    _clientesRepository = ClientesRepository(_database);

    primerValor.text = "5";
    segundoValor.text = "6";
    cantidad.text = "1";
    getClientData();
  }

  String forma = '1';
  List<DropdownMenuItem<String>> opcionesForma = [
    const DropdownMenuItem<String>(value: '1', child: Text('Rectangulo')),
    const DropdownMenuItem<String>(value: '2', child: Text('Cuadrado')),
    const DropdownMenuItem<String>(value: '3', child: Text('Ovalo')),
    const DropdownMenuItem<String>(value: '4', child: Text('Circulo'))
  ];

  String punta = '1';
  List<DropdownMenuItem<String>> opcionesPunta = [
    const DropdownMenuItem<String>(value: '1', child: Text('Normal')),
    const DropdownMenuItem<String>(value: '2', child: Text('Matada')),
    const DropdownMenuItem<String>(value: '3', child: Text('Roma 15 mm'))
  ];

  TextEditingController primerValor = TextEditingController();
  TextEditingController segundoValor = TextEditingController();
  TextEditingController cantidad = TextEditingController();

  bool formCuadradoCirculo = false;
  bool formRectanguloOvalo = true;

  final _formKey = GlobalKey<FormState>();

  Future<void> getClientData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      sp.reload();
      String? valor = sp.getString("idCliente");

      if (valor == null) {
        idCliente = 0;
      } else {
        idCliente = int.parse(sp.getString("idCliente").toString());
      }
    });
  }

  abrirDialogo() async {
    await loginDialog().whenComplete(() => setState(() {
          initVariables();
        }));
  }

  login(GlobalKey<FormState> key, TextEditingController correo,
      TextEditingController contra) async {
    String email = correo.text;
    String pwd = contra.text;
    if (key.currentState!.validate()) {
      await _clientesRepository.getClient(email, pwd).then((data) {
        if (data != null) {
          setSP(data).whenComplete(() {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text(
                "Se inicio sesión correctamente",
              ),
              duration: Duration(seconds: 2),
              backgroundColor: Colors.green,
            ));
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text(
              "No se encontro el usuario",
              style: TextStyle(color: Colors.black),
            ),
            duration: Duration(seconds: 2),
            backgroundColor: Colors.amber,
          ));
        }
      });
    }
  }

  void registrarCliente() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return const RegisterScreen();
    }));
  }

  Future setSP(Clientes user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("idCliente", user.idCliente.toString());
    sp.setString("nombre", user.nombre);
    sp.setString("primerApellido", user.primerApellido);
    sp.setString("segundoApellido", user.segundoApellido);
    sp.setString("genero", user.genero);
    sp.setString("dia", user.dia);
    sp.setString("mes", user.mes);
    sp.setString("anio", user.anio);
    sp.setString("calle", user.calle);
    sp.setString("numero", user.numero);
    sp.setString("colonia", user.colonia);
    sp.setString("cp", user.cp);
    sp.setString("ciudad", user.ciudad);
    sp.setString("estado", user.estado);
    sp.setString("correo", user.correo);
    sp.setString("correoRec", user.correoRec);
    sp.setString("contrasenia", user.contrasenia);
    sp.setString("estatus", user.estatus.toString());

    sp.reload();
  }

  Future<void> loginDialog() async {
    final conCorreo = TextEditingController();
    final conContrasenia = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool mostrarContrasenia = true;

    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text("Iniciar sesión"),
            content: const Text(
                "Es necesario iniciar sesión antes de realizar alguna compra."),
            actions: [
              TextFormField(
                  controller: conCorreo,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    RegExp email =
                        RegExp(r"[a-zA-Z0-9]+\@+[a-zA-Z]+\.+[a-zA-Z]");

                    if (value!.isEmpty) {
                      return "Se requiere ingresar un correo";
                    } else if (!email.hasMatch(value)) {
                      return "El correo no tiene el formato correcto";
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.email_outlined),
                      labelText: "Correo")),
              TextFormField(
                obscureText: mostrarContrasenia,
                controller: conContrasenia,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Se requiere ingresar la contraseña";
                  } else if (value.length <= 8) {
                    return "La contraseña debe ser mayor de 8 caracteres";
                  }
                  return null;
                },
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.lock),
                    labelText: "Contraseña",
                    suffixIcon: IconButton(
                        onPressed: () => setState(() {
                              mostrarContrasenia = !mostrarContrasenia;
                            }),
                        icon: CustomIcon(mostrar: mostrarContrasenia))),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                      child: TextButton(
                    child: const Text('Registrarse'),
                    onPressed: () {
                      registrarCliente();
                    },
                  )),
                  Expanded(
                      child: TextButton(
                    child: const Text('Iniciar sesión'),
                    onPressed: () {
                      login(formKey, conCorreo, conContrasenia);
                    },
                  ))
                ],
              )
            ],
          ),
        );
      },
    );
  }

  void agregarAlCarrito(
      String forma, String primerValor, String segundoValor) async {
    if (_formKey.currentState!.validate()) {
      if (idCliente != 0) {
        await productosRepository
            .getProduct(widget.nombre, widget.grosor)
            .then((data) async {
          int idVenta = 0;
          double subtotal = obtenerSubtotal(data!);
          double total = subtotal * int.parse(cantidad.text);
          double cmVendidos = obtenerCMVendidos();
          DateTime hoy = DateTime.now();
          DateTime entrega = hoy.add(const Duration(days: 2));
          String f = obtenerForma(forma);
          Ventas? venta =
              await _ventasRepository.getVentaAbiertaByClient(idCliente!);

          if (venta == null) {
            registerVenta(idVenta, hoy, entrega, idCliente!, total);
            venta = await _ventasRepository.getVentaAbiertaByClient(idCliente!);
            registerDetalle(venta!.idVenta, data.idProducto, subtotal, total,
                int.parse(cantidad.text), cmVendidos, f);
          } else {
            venta.total += total;
            _ventasRepository.update(venta);
            registerDetalle(venta.idVenta, data.idProducto, subtotal, total,
                int.parse(cantidad.text), cmVendidos, f);
          }
        }).whenComplete(() => Navigator.pop(context));
      } else {
        abrirDialogo();
      }
    }
  }

  registerVenta(int idVenta, DateTime hoy, DateTime entrega, int idCliente,
      double total) async {
    String fechaVenta = "${hoy.day}/${hoy.month}/${hoy.year}";
    String fechaEntrega = "${entrega.day}/${entrega.month}/${entrega.year}";

    var modelo = Ventas(idVenta, fechaVenta, fechaEntrega, idCliente, total, 1);
    await _ventasRepository.register(modelo);
  }

  registerDetalle(idVenta, idProducto, double subtotal, double total,
      int cantidad, double cmVendidos, String forma) async {
    var modelo = DetalleVentas(
        0, idVenta, idProducto, subtotal, cantidad, total, cmVendidos, forma);
    await _detalleVentasRepository.register(modelo);
  }

  double obtenerSubtotal(Productos p) {
    double subtotal = 0;

    double precioBase = obtenerPrecioBase(p.precioCompra);

    double area = obtenerArea(forma, primerValor.text, segundoValor.text);
    double merma =
        obtenerMerma(forma, primerValor.text, segundoValor.text, area);
    double precioMerma = obtenerPrecioMerma(forma, precioBase, merma);

    subtotal = (area * precioBase) + precioMerma;

    if (punta == "2") {
      subtotal += 200;
    } else if (punta == "3") {
      subtotal += 300;
    }

    return subtotal;
  }

  double obtenerPrecioBase(double precioCompra) {
    return (precioCompra / 90000);
  }

  double obtenerArea(String forma, String pV, String sV) {
    double area = 0;

    switch (forma) {
      case "1": //Rectangulo
        area = double.parse(pV) * double.parse(sV);
        break;
      case "2": //Cuadrado
        area = double.parse(pV) * double.parse(pV);
        break;
      case "3": //Ovalo
        double base = double.parse(pV) / 2;
        double altura = double.parse(pV) / 2;

        area = pi * base * altura;
        break;
      case "4": //Circulo
        double radio = double.parse(pV) / 2;
        area = (radio * radio) * pi;
        break;
      default:
    }

    return area;
  }

  double obtenerMerma(String forma, String pV, String sV, double area) {
    double merma = 0;
    if (forma == "1" || forma == "2") {
      merma = obtenerArea(forma, pV, sV) - area;
    }
    return merma;
  }

  double obtenerPrecioMerma(String forma, double precioBase, double merma) {
    double precio = 0;

    precio = precioBase * merma;

    switch (forma) {
      case "1":
        precio += 200;
        break;
      case "2":
        precio += 100;
        break;
      case "3":
        precio += 400;
        break;
      case "4":
        precio += 300;
        break;
      default:
    }

    return precio;
  }

  double obtenerCMVendidos() {
    double cm = 0;
    double area = obtenerArea(forma, primerValor.text, segundoValor.text);
    double merma =
        obtenerMerma(forma, primerValor.text, segundoValor.text, area);

    cm = area + merma;

    return cm;
  }

  String obtenerForma(String valor) {
    String f = "";
    switch (valor) {
      case "1":
        f = "Rectangulo";
        break;
      case "2":
        f = "Cuadrado";
        break;
      case "3":
        f = "Ovalo";
        break;
      case "4":
        f = "Circulo";
        break;
    }
    return f;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.nombre,
          style: const TextStyle(
              fontFamily: "Nunito", fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: HexColor("01688c"),
      ),
      body: Form(
        key: _formKey,
        child: Scrollbar(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                padding: const EdgeInsets.all(25),
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: Image(image: AssetImage(widget.img)),
                    ),
                    CustomInfo(vidrio: widget.nombre, grosor: widget.grosor),
                    const Text("Tipo de forma"),
                    DropdownButton(
                        value: forma,
                        isExpanded: true,
                        items: opcionesForma,
                        onChanged: (String? value) {
                          setState(() {
                            forma = value!;
                            if (forma == "1" || forma == "3") {
                              formCuadradoCirculo = false;
                              formRectanguloOvalo = true;
                            } else {
                              formRectanguloOvalo = false;
                              formCuadradoCirculo = true;
                            }
                          });
                        }),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Tipo de punta"),
                    DropdownButton(
                        value: punta,
                        isExpanded: true,
                        items: opcionesPunta,
                        onChanged: (String? value) {
                          setState(() {
                            punta = value!;
                          });
                        }),
                    CustomFormRO(
                        formRectanguloOvalo: formRectanguloOvalo,
                        forma: forma,
                        primerValor: primerValor,
                        segundoValor: segundoValor),
                    CustomFormCC(
                        formCuadradoCirculo: formCuadradoCirculo,
                        primerValor: primerValor,
                        forma: forma),
                    TextFormField(
                      controller: cantidad,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Por favor ingrese una cantidad';
                        } else {
                          if (value.contains(".") || value.contains(",")) {
                            return "La cantidad debe ser un entero";
                          }

                          double valor = double.parse(value);
                          if (valor <= 0) {
                            return "La cantidad debe ser mayor a 0";
                          }
                        }
                      },
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(labelText: "Cantidad"),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                        onPressed: () {
                          agregarAlCarrito(
                              forma, primerValor.text, segundoValor.text);
                        },
                        child: const Text(
                          "Agregar al carrito",
                          style: TextStyle(color: Colors.white),
                        ))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
