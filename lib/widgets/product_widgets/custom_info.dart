import 'package:flutter/material.dart';

class CustomInfo extends StatelessWidget {
  final String vidrio;
  final String grosor;
  const CustomInfo({
    Key? key,
    required this.vidrio,
    required this.grosor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String descripcion = "";

    if (vidrio == "Vidrio Simple") {
      descripcion =
          "El Vidrio Simple o Monolítico se trata de un vidrio base que puede ser sometido a distintos proceso de transformación, según su uso y aplicaciones deseadas.";
    } else if (vidrio == "Vidrio Laminado") {
      descripcion =
          "Los vidrios laminados están compuesto por dos o más lunas unidas por interposición de material plástico (butiral de polivinilo) elegida por sus grandes cualidades de resistencia, adherencia y elasticidad.";
    } else if (vidrio == "Vidrio Templado") {
      descripcion =
          "Las principales ventajas de los cristales templados son la seguridad y la resistencia de la estructura. El mejor cristal templado es cuatro veces más resistente que los cristales sin tratamiento, y si llega a romperse, se fragmenta en pequeñas piezas.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Grosor: $grosor mm",
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          descripcion,
          style: const TextStyle(
            fontSize: 18,
          ),
          textAlign: TextAlign.justify,
        ),
        const SizedBox(
          height: 10,
        )
      ],
    );
  }
}
