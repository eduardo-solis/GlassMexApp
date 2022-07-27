import 'package:flutter/material.dart';
import 'package:glassmex/screens/home_screen.dart';

void main() {
  runApp(const GlassMex());
}

class GlassMex extends StatelessWidget {
  const GlassMex({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}
