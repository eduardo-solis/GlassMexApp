class Clientes {
  late int idCliente;
  late String nombre;
  late String primerApellido;
  late String segundoApellido;
  late String genero;
  late String dia;
  late String mes;
  late String anio;
  late String calle;
  late String numero;
  late String colonia;
  late String cp;
  late String ciudad;
  late String estado;
  late String correo;
  late String correoRec;
  late String contrasenia;
  late int estatus;

  Clientes(
      this.idCliente,
      this.nombre,
      this.primerApellido,
      this.segundoApellido,
      this.genero,
      this.dia,
      this.mes,
      this.anio,
      this.calle,
      this.numero,
      this.colonia,
      this.cp,
      this.ciudad,
      this.estado,
      this.correo,
      this.correoRec,
      this.contrasenia,
      this.estatus);

  Map<String, dynamic> mapForInsert() {
    return {
      'nombre': nombre,
      'primerApellido': primerApellido,
      'segundoApellido': segundoApellido,
      'genero': genero,
      'dia': dia,
      'mes': mes,
      'anio': anio,
      'calle': calle,
      'numero': numero,
      'colonia': colonia,
      'cp': cp,
      'ciudad': ciudad,
      'estado': estado,
      'correo': correo,
      'correoRec': correoRec,
      'contrasenia': contrasenia,
      'estatus': estatus
    };
  }

  Map<String, dynamic> mapForUpdate() {
    return {
      'idCliente': idCliente.toString(),
      'calle': calle,
      'numero': numero,
      'colonia': colonia,
      'cp': cp,
      'ciudad': ciudad,
      'estado': estado,
      'correo': correo,
      'correoRec': correoRec,
      'contrasenia': contrasenia
    };
  }

  Map<String, dynamic> mapForDelete() {
    return {'idCliente': idCliente.toString()};
  }

  Clientes.formMap(Map<String, dynamic> map) {
    idCliente = map["idCliente"];
    nombre = map["nombre"];
    primerApellido = map["primerApellido"];
    segundoApellido = map["segundoApellido"];
    genero = map["genero"];
    dia = map["dia"];
    mes = map["mes"];
    anio = map["anio"];
    calle = map["calle"];
    numero = map["numero"];
    colonia = map["colonia"];
    cp = map["cp"];
    ciudad = map["ciudad"];
    estado = map["estado"];
    correo = map["correo"];
    correoRec = map["correoRec"];
    contrasenia = map["contrasenia"];
    estatus = map["estatus"];
  }
}
