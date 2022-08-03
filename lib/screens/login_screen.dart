import 'package:flutter/material.dart';
import 'package:glassmex/models/clientes.dart';

import 'package:sqflite/sqflite.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
