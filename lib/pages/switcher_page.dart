import 'package:flutter/material.dart';
import 'package:dosantonias_app/pages/pages.dart';

class SwitcherPage extends StatefulWidget {
  const SwitcherPage({super.key});

  @override
  State<SwitcherPage> createState() => _SwitcherPageState();
}

class _SwitcherPageState extends State<SwitcherPage> {
  //este booleano es para indicar que se inicia con el login page
  bool showLoginPage = true;

  //el switcher
  void switcher() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (showLoginPage) {
      return LoginPage(
        onTap: switcher,
      );
    } else {
      return RegisterPage(
        onTap: switcher,
      );
    }
  }
}
