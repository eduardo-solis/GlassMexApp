class Productos {
  late int idProducto;
  late String nombre;
  late String descripcion;
  late String grosor;
  late String img;
  late double precioCompra;

  Productos(this.idProducto, this.nombre, this.grosor, this.img,
      this.descripcion, this.precioCompra);

  Map<String, dynamic> mapForInsert() {
    return {
      "nombre": nombre,
      "descripcion": descripcion,
      "grosor": grosor,
      "img": img,
      "precioCompra": precioCompra
    };
  }

  Productos.forMap(Map<String, dynamic> map) {
    idProducto = map["idProducto"];
    nombre = map["nombre"];
    descripcion = map["descripcion"];
    grosor = map["grosor"];
    img = map["img"];
    precioCompra = map["precioCompra"];
  }
}
