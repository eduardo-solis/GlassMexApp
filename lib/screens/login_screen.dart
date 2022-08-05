import 'package:flutter/material.dart';
import 'package:glassmex/models/clientes.dart';
import 'dart:convert';

import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../database/db_connection.dart';
import '../repositories/clientes_repository.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Persistencia de datos
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  // Inicializando la base de datos
  late Database _database;
  late ClientesRepository _clientesRepository;

  final _conCorreo = TextEditingController();
  final _conContrasenia = TextEditingController();

  bool mostrarContrasenia = true;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    _clientesRepository = ClientesRepository(_database);
  }

  void login() async {
    String email = _conCorreo.text;
    String pwd = _conContrasenia.text;

    if (_formKey.currentState!.validate()) {
      await _clientesRepository.getClient(email, pwd).then((data) {
        if (data != null) {
          setSP(data).whenComplete(() {
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text(
                "Se inicio sesión correctamente",
              ),
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.green,
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
              "No se encontro el usuario",
              style: TextStyle(color: Colors.black),
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
      });
    }
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

  void registrarCliente() {
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return const RegisterScreen();
    }));
  }

  Future recuperarContrasenia(Clientes cliente) async {
    final url = Uri.parse("https://api.emailjs.com/api/v1.0/email/send");
    const serviceId = 'service_j0rnl8q';
    const templateId = 'template_tyr3eno';
    const userId = 'ys1dCtm6egTasQdLn';
    const token = "pB8pjcts-dOpxoP9qrcG-";

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': userId,
          'accessToken': token,
          'template_params': {
            'user':
                '${cliente.nombre} ${cliente.primerApellido} ${cliente.segundoApellido}',
            'account': cliente.correo,
            'password': cliente.contrasenia,
            'user_email': cliente.correoRec
          }
        }));
    print("Estatus ${response.statusCode} ");
    print("Body ${response.body} ");
    return response.statusCode;
  }

  buscarCliente(String correo) async {
    await _clientesRepository.getClientByEmail(correo).then((value) async {
      if (value != null) {
        await recuperarContrasenia(value).whenComplete(() {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: const Text(
              "Se ha enviado el correo",
              style: TextStyle(color: Colors.black),
            ),
            duration: const Duration(seconds: 2),
            backgroundColor: Colors.green,
            elevation: 0,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ));
        });
      } else {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: const Text(
            "No se encontro el usuario",
            style: TextStyle(color: Colors.black),
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
    }).onError((error, stackTrace) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Text(
          "Ha ocurrido un error",
          style: TextStyle(color: Colors.black),
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
  }

  Future recuperarContraDialog() async {
    TextEditingController conCorreo = TextEditingController();
    final formKey = GlobalKey<FormState>();

    return showDialog(
      context: context,
      builder: (context) {
        return Form(
          key: formKey,
          child: AlertDialog(
            title: const Text("Recuperar contraseña"),
            content: const Text(
                "Escribe el correo asociado a la cuenta, se enviara la contraseña al correo de recuperación que se haya registrado para la cuenta."),
            actions: [
              TextFormField(
                controller: conCorreo,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                    label: Text("Correo"),
                    prefixIcon: Icon(Icons.email_outlined)),
                validator: (value) {
                  RegExp email = RegExp(r"[a-zA-Z0-9]+\@+[a-zA-Z]+\.+[a-zA-Z]");

                  if (value!.isEmpty) {
                    return "Se requiere ingresar un correo";
                  } else if (!email.hasMatch(value)) {
                    return "El correo no tiene el formato correcto";
                  }
                  return null;
                },
              ),
              TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      buscarCliente(conCorreo.text);
                    }
                  },
                  child: const Text("Recuperar"))
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
          title: const Text("Inicar Sesión"),
          backgroundColor: HexColor("01688c")),
      body: Form(
        key: _formKey,
        child: Center(
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                    width: 225,
                    height: 225,
                    child:
                        const Image(image: AssetImage("assets/img/user.png")),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                      controller: _conCorreo,
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
                    controller: _conContrasenia,
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
                  const SizedBox(height: 25),
                  ElevatedButton(
                      onPressed: login, child: const Text("Iniciar Sesión")),
                  TextButton(
                      onPressed: registrarCliente,
                      child: Text(
                        "Registrate!!",
                        style: TextStyle(
                            color: HexColor("01688c"),
                            decoration: TextDecoration.underline),
                      )),
                  TextButton(
                      onPressed: recuperarContraDialog,
                      child: Text(
                        "Recuperar contraseña",
                        style: TextStyle(
                            color: HexColor("01688c"),
                            decoration: TextDecoration.underline),
                      ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CustomIcon extends StatelessWidget {
  final bool mostrar;
  const CustomIcon({
    Key? key,
    required this.mostrar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (mostrar) {
      return const Icon(Icons.visibility_off_outlined);
    } else {
      return const Icon(Icons.visibility_outlined);
    }
  }
}
