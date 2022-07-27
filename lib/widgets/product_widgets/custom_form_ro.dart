import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomFormRO extends StatelessWidget {
  const CustomFormRO({
    Key? key,
    required this.formRectanguloOvalo,
    required this.primerValor,
    required this.segundoValor,
    required this.forma,
  }) : super(key: key);

  final bool formRectanguloOvalo;
  final String forma;
  final TextEditingController primerValor;
  final TextEditingController segundoValor;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: formRectanguloOvalo,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                  flex: 5,
                  child: TextFormField(
                    controller: primerValor,
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
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(labelText: "Ancho"),
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
                        if (valor < 6 || valor > 360) {
                          return "El valor debe ser entre 6 y 360 cm";
                        }
                      }
                    },
                    controller: segundoValor,
                    textAlign: TextAlign.end,
                    decoration: const InputDecoration(labelText: "Alto"),
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
              const Expanded(child: Text("cm"))
            ],
          ),
        ],
      ),
    );
  }
}
