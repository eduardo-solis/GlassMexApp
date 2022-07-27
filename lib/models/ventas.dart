class Ventas {
  late int idVenta;
  late String fechaVenta;
  late String fechaEntrega;
  late int idCliente;
  late double total;
  late int estatus;

  Ventas(this.idVenta, this.fechaVenta, this.fechaEntrega, this.idCliente,
      this.total, this.estatus);

  Map<String, dynamic> mapForInsert() {
    return {
      'fechaVenta': fechaVenta,
      'fechaEntrega': fechaEntrega,
      'idCliente': idCliente,
      'total': total,
      'estatus': estatus
    };
  }

  Map<String, dynamic> mapForUpdate() {
    return {'idVenta': idVenta.toString(), 'total': total};
  }

  Map<String, dynamic> mapForPay() {
    return {'idVenta': idVenta.toString(), 'estatus': estatus};
  }

  Map<String, dynamic> mapForDelete() {
    return {'idVenta': idVenta.toString()};
  }

  Ventas.fromMap(Map<String, dynamic> map) {
    idVenta = map["idVenta"];
    idCliente = map["idCliente"];
    fechaVenta = map["fechaVenta"];
    fechaEntrega = map["fechaEntrega"];
    total = map["total"];
    estatus = map["estatus"];
  }
}
