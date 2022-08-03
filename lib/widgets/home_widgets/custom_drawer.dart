import 'package:flutter/material.dart';
import 'package:glassmex/screens/my_purchases_screen.dart';
import 'package:glassmex/screens/shopping_cart_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:glassmex/helpers/hexcolor.dart';
import 'package:glassmex/screens/register_screen.dart';
import '../../screens/login_screen.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({
    Key? key,
  }) : super(key: key);

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  final Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String? nombreCliente = "";
  String? id = "0";
  bool mostrarLogin = true;
  bool mostrarLogout = false;
  bool mostrarPerfil = false;
  bool mostrarCarrito = false;
  bool mostrarCompras = false;

  @override
  void initState() {
    super.initState();
    getClientData();
  }

  Future<void> getClientData() async {
    final SharedPreferences sp = await _pref;
    sp.reload();
    setState(() {
      var valor = sp.getString("idCliente").toString();
      if (valor != "null") {
        mostrarLogin = false;
        mostrarLogout = true;
        mostrarPerfil = true;
        mostrarCarrito = true;
        mostrarCompras = true;
        nombreCliente = sp.getString("nombre");
        id = valor;
      }
    });
  }

  logout() async {
    final SharedPreferences sp = await _pref;
    nombreCliente = " ";
    id = "0";
    mostrarLogin = true;
    mostrarLogout = false;
    mostrarPerfil = false;
    mostrarCarrito = true;
    mostrarCompras = true;

    sp.remove("idCliente");
    sp.remove("nombre");
    sp.remove("primerApellido");
    sp.remove("segundoApellido");
    sp.remove("genero");
    sp.remove("dia");
    sp.remove("mes");
    sp.remove("anio");
    sp.remove("calle");
    sp.remove("numero");
    sp.remove("colonia");
    sp.remove("cp");
    sp.remove("ciudad");
    sp.remove("estado");
    sp.remove("correo");
    sp.remove("correoRec");
    sp.remove("contrasenia");
    sp.reload();
    setState(() {});
    cerrarSesion();
  }

  void cerrarSesion() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text(
        "Se cerro la sesión",
        style: TextStyle(color: Colors.black),
      ),
      duration: Duration(seconds: 2),
      backgroundColor: Colors.amber,
    ));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    void iniciarSesion() {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return const LoginScreen();
      }));
    }

    void perfil() {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return RegisterScreen(
          idUser: int.parse(id.toString()),
        );
      }));
    }

    void shoppingCart() {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return ShoppingCartScreen(
          idUser: int.parse(id.toString()),
        );
      }));
    }

    myPurchases() {
      Navigator.pop(context);
      Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) {
        return MyPurchasesScreen(
          idUser: int.parse(id.toString()),
        );
      }));
    }

    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: HexColor("01688c")),
            child: Column(
              children: [
                const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 75,
                ),
                const SizedBox(
                  height: 10,
                ),
                Text(
                  nombreCliente.toString(),
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "Nunito",
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Visibility(
            visible: mostrarPerfil,
            child: ListTile(
              leading: const Icon(Icons.assignment_ind_outlined),
              title: const Text("Perfil"),
              onTap: perfil,
            ),
          ),
          Visibility(
            visible: mostrarCarrito,
            child: ListTile(
              leading: const Icon(Icons.shopping_cart_outlined),
              title: const Text("Carrito de compras"),
              onTap: shoppingCart,
            ),
          ),
          Visibility(
            visible: mostrarCompras,
            child: ListTile(
              leading: const Icon(Icons.shopping_bag_outlined),
              title: const Text("Mis compras"),
              onTap: myPurchases,
            ),
          ),
          const Divider(),
          Visibility(
            visible: mostrarLogin,
            child: ListTile(
              leading: const Icon(Icons.login_outlined),
              title: const Text("Iniciar sesión"),
              onTap: iniciarSesion,
            ),
          ),
          Visibility(
            visible: mostrarLogout,
            child: ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text("Cerrar sesión"),
              onTap: logout,
            ),
          ),
        ],
      ),
    );
  }
}
