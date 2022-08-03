import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/models/clientes.dart';
import 'package:glassmex/repositories/clientes_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

class RegisterScreen extends StatefulWidget {
  final int idUser;

  const RegisterScreen({Key? key, this.idUser = 0}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Persistencia de datos
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  // Inicializando la base de datos
  late Database _database;
  late ClientesRepository _clientesRepository;

  // Datos del formulario
  TextEditingController nombre = TextEditingController();
  TextEditingController primerApellido = TextEditingController();
  TextEditingController segundoApellido = TextEditingController();
  late String genero = "H";
  List<DropdownMenuItem<String>> comboGenero = [
    const DropdownMenuItem<String>(value: 'H', child: Text('Hombre')),
    const DropdownMenuItem<String>(value: 'M', child: Text('Mujer'))
  ];
  late String campoDia = "1";
  late String campoMes = "1";
  TextEditingController anio = TextEditingController();
  TextEditingController calle = TextEditingController();
  TextEditingController numero = TextEditingController();
  TextEditingController colonia = TextEditingController();
  TextEditingController cp = TextEditingController();
  late String campoCiudad = "León";
  List<DropdownMenuItem<String>> comboCiudad = [
    const DropdownMenuItem<String>(value: 'León', child: Text('León')),
    const DropdownMenuItem<String>(
        value: 'Guanajuato', child: Text('Guanajuato')),
    const DropdownMenuItem<String>(value: 'Celaya', child: Text('Calaya'))
  ];
  late String campoEstado = "Guanajuato";
  List<DropdownMenuItem<String>> comboEstado = [
    const DropdownMenuItem<String>(
        value: 'Guanajuato', child: Text('Guanajuato')),
    const DropdownMenuItem<String>(
        value: 'Nuevo León', child: Text('Nuevo León')),
    const DropdownMenuItem<String>(value: 'Chiapas', child: Text('Chiapas'))
  ];
  TextEditingController correo = TextEditingController();
  TextEditingController correoRec = TextEditingController();
  TextEditingController contrasenia = TextEditingController();

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    _clientesRepository = ClientesRepository(_database);
    getClientData();
  }

  Future<void> getClientData() async {
    final SharedPreferences sp = await _pref;
    setState(() {
      if (widget.idUser != 0) {
        nombre.text = sp.getString("nombre").toString();
        primerApellido.text = sp.getString("primerApellido").toString();
        segundoApellido.text = sp.getString("segundoApellido").toString();
        genero = sp.getString("genero").toString();
        campoDia = sp.getString("dia").toString();
        campoMes = sp.getString("mes").toString();
        anio.text = sp.getString("anio").toString();
        calle.text = sp.getString("calle").toString();
        numero.text = sp.getString("numero").toString();
        colonia.text = sp.getString("colonia").toString();
        cp.text = sp.getString("cp").toString();
        campoCiudad = sp.getString("ciudad").toString();
        campoEstado = sp.getString("estado").toString();
        correo.text = sp.getString("correo").toString();
        correoRec.text = sp.getString("correoRec").toString();
        contrasenia.text = sp.getString("contrasenia").toString();
      }
    });
  }

  void guardar() {
    if (widget.idUser == 0) {
      register();
      Navigator.pop(context);
    } else {
      update();
      Navigator.pop(context);
    }
  }

  register() async {
    String name = nombre.text;
    String lastName = primerApellido.text;
    String secondLastName = segundoApellido.text;
    String genre = genero;
    String day = campoDia;
    String month = campoMes;
    String year = anio.text;
    String street = calle.text;
    String number = numero.text;
    String colony = colonia.text;
    String zipCode = cp.text;
    String city = campoCiudad;
    String state = campoEstado;
    String email = correo.text;
    String emailRec = correoRec.text;
    String pwd = contrasenia.text;

    var modelo = Clientes(
        0,
        name,
        lastName,
        secondLastName,
        genre,
        day,
        month,
        year,
        street,
        number,
        colony,
        zipCode,
        city,
        state,
        email,
        emailRec,
        pwd,
        1);

    await _clientesRepository.register(modelo);

    limpiarCampos();
  }

  update() async {
    String name = nombre.text;
    String lastName = primerApellido.text;
    String secondLastName = segundoApellido.text;
    String genre = genero;
    String day = campoDia;
    String month = campoMes;
    String year = anio.text;
    String street = calle.text;
    String number = numero.text;
    String colony = colonia.text;
    String zipCode = cp.text;
    String city = campoCiudad;
    String state = campoEstado;
    String email = correo.text;
    String emailRec = correoRec.text;
    String pwd = contrasenia.text;

    var modelo = Clientes(
        widget.idUser,
        name,
        lastName,
        secondLastName,
        genre,
        day,
        month,
        year,
        street,
        number,
        colony,
        zipCode,
        city,
        state,
        email,
        emailRec,
        pwd,
        1);

    int id = await _clientesRepository.update(modelo);
    await _clientesRepository.getClientById(id.toString()).then((data) {
      if (data != null) {
        setSP(data).whenComplete(() {});
      }
    });
    limpiarCampos();
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

  void boton(int id) {
    guardar();
  }

  limpiarCampos() {
    nombre.text = "";
    primerApellido.text = "";
    segundoApellido.text = "";
    genero = "H";
    campoDia = "1";
    campoMes = "1";
    anio.text = "";
    calle.text = "";
    numero.text = "";
    colonia.text = "";
    cp.text = "";
    campoCiudad = "León";
    campoEstado = "Guanajuato";
    correo.text = "";
    correoRec.text = "";
    contrasenia.text = "";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registro"),
        backgroundColor: HexColor("01688c"),
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        child: Scrollbar(
            child: ListView(
          children: [
            TextFormField(
                enabled: widget.idUser != 0 ? false : true,
                decoration: InputDecoration(
                    labelText: "Nombre",
                    fillColor:
                        widget.idUser != 0 ? Colors.grey[300] : Colors.white,
                    filled: true),
                controller: nombre,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5 || value.length > 5) {
                    return "El Nombre debe ser por lo menos de 5 caracteres";
                  }
                  return null;
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                enabled: widget.idUser != 0 ? false : true,
                decoration: InputDecoration(
                    labelText: "Primer Apellido",
                    fillColor:
                        widget.idUser != 0 ? Colors.grey[300] : Colors.white,
                    filled: true),
                controller: primerApellido,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5 || value.length > 5) {
                    return "El Primer Apellido debe ser por lo menos de 5 caracteres";
                  }
                  return null;
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              enabled: widget.idUser != 0 ? false : true,
              decoration: InputDecoration(
                  labelText: "Segundo Apellido",
                  fillColor:
                      widget.idUser != 0 ? Colors.grey[300] : Colors.white,
                  filled: true),
              controller: segundoApellido,
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: widget.idUser != 0 ? false : true,
              child: const Text(
                "Genero",
                style: TextStyle(fontSize: 17),
              ),
            ),
            Visibility(
              visible: widget.idUser != 0 ? false : true,
              child: DropdownButton(
                  value: genero,
                  isExpanded: true,
                  items: comboGenero,
                  onChanged: (String? value) {
                    setState(() {
                      genero = value!;
                    });
                  }),
            ),
            const SizedBox(
              height: 15,
            ),
            Visibility(
              visible: widget.idUser != 0 ? false : true,
              child: const Text(
                "Fecha de nacimiento",
                style: TextStyle(fontSize: 17),
              ),
            ),
            const SizedBox(height: 15),
            Visibility(
              visible: widget.idUser != 0 ? false : true,
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Dia"),
                        DropdownButton(
                            value: campoDia,
                            onChanged: (String? value) {
                              setState(() {
                                campoDia = value!;
                              });
                            },
                            items: List.generate(32, (index) => index + 1)
                                .map<DropdownMenuItem<String>>((int value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                  const Expanded(child: Text("/")),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Mes"),
                        DropdownButton(
                            value: campoMes,
                            onChanged: (String? value) {
                              setState(() {
                                campoMes = value!;
                              });
                            },
                            items: List.generate(12, (index) => index + 1)
                                .map<DropdownMenuItem<String>>((int value) {
                              return DropdownMenuItem<String>(
                                value: value.toString(),
                                child: Text(value.toString()),
                              );
                            }).toList()),
                      ],
                    ),
                  ),
                  const Expanded(child: Text("/")),
                  Expanded(
                    child: TextFormField(
                        decoration: const InputDecoration(labelText: "Año"),
                        controller: anio,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        validator: (value) {
                          if (value!.isEmpty ||
                              value.length <= 3 ||
                              value.length >= 5) {
                            return "El año debe ser de 4 caracteres";
                          }
                          return null;
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: "Calle"),
                controller: calle,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5 || value.length > 5) {
                    return "La calle debe ser de 5 caracteres";
                  }
                  return null;
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Número"),
              controller: numero,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return "El numero debe tener un valor";
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                decoration: const InputDecoration(labelText: "Colonia"),
                controller: colonia,
                validator: (value) {
                  if (value!.isEmpty || value.length < 5 || value.length > 5) {
                    return "La colonia debe ser de 5 caracteres";
                  }
                  return null;
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "C.P."),
              controller: cp,
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty || value.length < 5 || value.length > 5) {
                  return "El cp debe ser de 5 caracteres";
                }
                return null;
              },
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(
              height: 15,
            ),
            const Text("Ciudad"),
            DropdownButton(
                value: campoCiudad,
                isExpanded: true,
                items: comboCiudad,
                onChanged: (String? value) {
                  setState(() {
                    campoCiudad = value!;
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            const Text("Estado"),
            DropdownButton(
                value: campoEstado,
                isExpanded: true,
                items: comboEstado,
                onChanged: (String? value) {
                  setState(() {
                    campoEstado = value!;
                  });
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Correo"),
              validator: (value) {
                RegExp email = RegExp(r"[a-zA-Z0-9]+\@+[a-zA-Z]+\.+[a-zA-Z]");

                if (value!.isEmpty) {
                  return "Se requiere ingresar un correo";
                } else if (!email.hasMatch(value)) {
                  return "El correo no tiene el formato correcto";
                }
                return null;
              },
              controller: correo,
            ),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
                decoration:
                    const InputDecoration(labelText: "Correo de recuperacion"),
                controller: correoRec,
                validator: (value) {
                  RegExp email = RegExp(r"[a-zA-Z0-9]+\@+[a-zA-Z]+\.+[a-zA-Z]");

                  if (value!.isEmpty) {
                    return "Se requiere ingresar un correo";
                  } else if (!email.hasMatch(value)) {
                    return "El correo no tiene el formato correcto";
                  }
                  return null;
                }),
            const SizedBox(
              height: 15,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Contraseña"),
              controller: contrasenia,
              validator: (value) {
                if (value!.isEmpty || value.length <= 7) {
                  return "Ingrese un valor igual o mayor a 8 caracteres";
                }
                return null;
              },
            ),
            const SizedBox(
              height: 15,
            ),
            ElevatedButton(
                onPressed: () => boton(widget.idUser),
                child: LabelButton(id: widget.idUser)),
          ],
        )),
      ),
    );
  }
}

class LabelButton extends StatelessWidget {
  final int id;
  const LabelButton({
    Key? key,
    required this.id,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (id != 0) {
      return const Text("Guardar");
    } else {
      return const Text("Registrar");
    }
  }
}
