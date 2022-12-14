import 'package:flutter/material.dart';
import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/screens/product_screen.dart';

class CustomItemListView extends StatefulWidget {
  final String image;
  final String nombre;
  final String grosor;

  const CustomItemListView({
    Key? key,
    required this.image,
    required this.nombre,
    required this.grosor,
  }) : super(key: key);

  @override
  State<CustomItemListView> createState() => _CustomItemListViewState();
}

class _CustomItemListViewState extends State<CustomItemListView> {
  bool isVisibility = false;

  void irDetalleProducto(String nombre, String grosor, String img) {
    //Se dirige al detalle del producto
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) {
      return ProductScreen(nombre: nombre, grosor: grosor, img: img);
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.black, blurRadius: 1)],
          borderRadius: BorderRadius.all(Radius.circular(15))),
      margin: const EdgeInsets.all(15),
      child: Column(
        children: [
          GestureDetector(
            onTap: () => setState(() {
              isVisibility = !isVisibility;
            }),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage(widget.image),
                  height: 125,
                  width: 125,
                ),
                Column(
                  children: [
                    Text(
                      widget.nombre,
                      style: const TextStyle(fontSize: 18),
                    ),
                    Text(widget.grosor, style: const TextStyle(fontSize: 18)),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: HexColor("01688c")),
                  child: Icon(isVisibility ? Icons.remove : Icons.add,
                      size: 30, color: Colors.white),
                )
              ],
            ),
          ),
          Visibility(
              visible: isVisibility,
              child: Column(
                children: [
                  ListTile(
                    title: const Text("Grosor 4 mm"),
                    trailing: Icon(Icons.arrow_forward_ios_outlined,
                        color: HexColor("01688c")),
                    onTap: () {
                      irDetalleProducto(widget.nombre, "4", widget.image);
                    },
                  ),
                  ListTile(
                    title: const Text("Grosor 6 mm"),
                    trailing: Icon(Icons.arrow_forward_ios_outlined,
                        color: HexColor("01688c")),
                    onTap: () {
                      irDetalleProducto(widget.nombre, "6", widget.image);
                    },
                  ),
                  ListTile(
                    title: const Text("Grosor 10 mm"),
                    trailing: Icon(Icons.arrow_forward_ios_outlined,
                        color: HexColor("01688c")),
                    onTap: () {
                      irDetalleProducto(widget.nombre, "10", widget.image);
                    },
                  )
                ],
              ))
        ],
      ),
    );
  }
}
