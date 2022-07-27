class DetalleVentas {
  int idDetalleVenta;
  int idVenta;
  int idProducto;
  double precioUnitario;
  int cantidad;
  double subtotal;
  double cmcVendidos;
  String forma;

  DetalleVentas(
      this.idDetalleVenta,
      this.idVenta,
      this.idProducto,
      this.precioUnitario,
      this.cantidad,
      this.subtotal,
      this.cmcVendidos,
      this.forma);

  Map<String, dynamic> mapForInsert() {
    return {
      'idVenta': idVenta.toString(),
      'idProducto': idProducto.toString(),
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'subtotal': subtotal,
      'cmcVendidos': cmcVendidos,
      'forma': forma
    };
  }

  Map<String, dynamic> mapForUpdate() {
    return {
      'idDetalleVenta': idDetalleVenta.toString(),
      'idVenta': idVenta.toString(),
      'idProducto': idProducto.toString(),
      'precioUnitario': precioUnitario,
      'cantidad': cantidad,
      'subtotal': subtotal,
      'cmcVendidos': cmcVendidos,
      'forma': forma
    };
  }

  Map<String, dynamic> mapForDelete() {
    return {'idDetalleVenta': idDetalleVenta.toString()};
  }
}
