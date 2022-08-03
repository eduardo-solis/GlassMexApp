import 'package:flutter/material.dart';
import 'package:glassmex/database/db_connection.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/repositories/productos_repository.dart';

import 'package:glassmex/widgets/home_widgets/custom_carousel.dart';
import 'package:glassmex/widgets/home_widgets/custom_drawer.dart';
import 'package:glassmex/widgets/home_widgets/custom_item_list_view.dart';
import 'package:sqflite/sqflite.dart';

import '../models/productos.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController buscar = TextEditingController();
  late Database _database;
  late ProductosRepository productosRepository;
  List<Productos> productos = List.empty();

  @override
  void initState() {
    super.initState();
    initVariables();
  }

  initVariables() async {
    _database = await DataBaseConnection.initiateDataBase();
    productosRepository = ProductosRepository(_database);
    refreshGrid();
  }

  refreshGrid() async {
    var nuevosProductos = await productosRepository.getAll();

    if (nuevosProductos.isEmpty) {
      for (var i = 0; i < 9; i++) {
        if (i < 3) {
          var modelo = Productos(
              0,
              "Vidrio Simple",
              "4",
              "assets/img/vidrio_simple.jpg",
              "El Vidrio Simple o Monolítico se trata de un vidrio base que puede ser sometido a distintos proceso de transformación, según su uso y aplicaciones deseadas.",
              4860);
          if (i == 1) {
            modelo.grosor = "6";
            modelo.precioCompra = 5265;
          }
          if (i == 2) {
            modelo.grosor = "10";
            modelo.precioCompra = 6075;
          }
          await productosRepository.register(modelo);
        }

        if (i >= 3 && i <= 5) {
          var modelo = Productos(
              0,
              "Vidrio Templado",
              "4",
              "assets/img/vidrio_templado.jpg",
              "Las principales ventajas de los cristales templados son la seguridad y la resistencia de la estructura. El mejor cristal templado es cuatro veces más resistente que los cristales sin tratamiento, y si llega a romperse, se fragmenta en pequeñas piezas.",
              5535);
          if (i == 4) {
            modelo.grosor = "6";
            modelo.precioCompra = 5940;
          }
          if (i == 5) {
            modelo.grosor = "10";
            modelo.precioCompra = 6750;
          }
          await productosRepository.register(modelo);
        }

        if (i > 5) {
          var modelo = Productos(
              0,
              "Vidrio Laminado",
              "4",
              "assets/img/vidrio_laminado.jpg",
              "Los vidrios laminados están compuesto por dos o más lunas unidas por interposición de material plástico (butiral de polivinilo) elegida por sus grandes cualidades de resistencia, adherencia y elasticidad.",
              5872.50);
          if (i == 7) {
            modelo.grosor = "6";
            modelo.precioCompra = 6277.50;
          }
          if (i == 8) {
            modelo.grosor = "10";
            modelo.precioCompra = 7087.50;
          }
          await productosRepository.register(modelo);
        }
      }

      nuevosProductos = await productosRepository.getAll();
    }

    setState(() {
      productos = nuevosProductos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: HexColor("01688c"),
        centerTitle: true,
        title: const Text("GlassMex",
            style: TextStyle(
                letterSpacing: 4,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: "Nunito")),
      ),
      drawer: const CustomDrawer(),
      body: Center(
        child: Scrollbar(
          child: ListView(
            children: const [
              SizedBox(
                height: 10,
              ),
              CustomCarousel(),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Elige de nuestro catálogo!!",
                  style: TextStyle(fontSize: 20),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              CustomItemListView(
                image: "assets/img/vidrio_simple.jpg",
                nombre: "Vidrio Simple",
                grosor: "",
              ),
              CustomItemListView(
                image: "assets/img/vidrio_templado.jpg",
                nombre: "Vidrio Templado",
                grosor: "",
              ),
              CustomItemListView(
                image: "assets/img/vidrio_laminado.jpg",
                nombre: "Vidrio Laminado",
                grosor: "",
              )
            ],
          ),
        ),
      ),
    );
  }
}
