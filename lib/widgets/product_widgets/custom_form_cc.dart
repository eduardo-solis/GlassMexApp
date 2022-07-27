import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormCC extends StatelessWidget {
  const CustomFormCC({
    Key? key,
    required this.formCuadradoCirculo,
    required this.primerValor,
    required this.forma,
  }) : super(key: key);

  final bool formCuadradoCirculo;
  final TextEditingController primerValor;
  final String forma;

  @override
  Widget build(BuildContext context) {
    if (forma == "2") {
      // Cuadrado
      return Visibility(
          visible: formCuadradoCirculo,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextFormField(
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese una medida';
                          } else {
                            double valor = double.parse(value);
                            if (valor < 5 || valor > 250) {
                              return "El valor debe ser entre 5 y 250 cm";
                            }
                          }
                        },
                        controller: primerValor,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(labelText: "Lado"),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            try {
                              final text = newValue.text;
                              if (text.isNotEmpty) double.parse(text);
                              return newValue;
                            } catch (e) {}
                            return oldValue;
                          }),
                        ],
                      )),
                  const Expanded(
                    child: Text(
                      "cm",
                    ),
                  )
                ],
              ),
            ],
          ));
    } else {
      return Visibility(
          visible: formCuadradoCirculo,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                      flex: 5,
                      child: TextFormField(
                        controller: primerValor,
                        textAlign: TextAlign.end,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Por favor ingrese una medida';
                          } else {
                            double valor = double.parse(value);
                            if (valor < 5 || valor > 250) {
                              return "El valor debe ser entre 5 y 250 cm";
                            }
                          }
                        },
                        decoration:
                            const InputDecoration(labelText: "Diametro"),
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true, signed: false),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r"[0-9.]")),
                          TextInputFormatter.withFunction((oldValue, newValue) {
                            try {
                              final text = newValue.text;
                              if (text.isNotEmpty) double.parse(text);
                              return newValue;
                            } catch (e) {}
                            return oldValue;
                          }),
                        ],
                      )),
                  const Expanded(
                    child: Text(
                      "cm",
                    ),
                  )
                ],
              ),
            ],
          ));
    }
  }
}
