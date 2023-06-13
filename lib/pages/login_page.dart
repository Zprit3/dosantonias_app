import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();

  void signUserIn() async {
    //carga
    showDialog(
        context: context,
        builder: (context) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'user-not-fount') {
        malEmail();
        //print('No se ha encontrado el email');
      } else if (e.code == 'wrong-password') {
        //print('Contraseña equivocada');
        malPassword();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('lib/images/BGbasic.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Color.fromARGB(255, 255, 255, 255).withOpacity(0.9),
              BlendMode.luminosity,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //logo
                Image.asset(
                  'lib/images/icoMainBW.png',
                  height: 100,
                  width: 100,
                ),
                const SizedBox(height: 30),
                //mensaje de bienvenida

                //Campo Usuario
                TextFieldW(
                  controller: emailController,
                  hintText: 'Email',
                  obscureText: false,
                ),

                const SizedBox(height: 10),
                //contraseña
                TextFieldW(
                  controller: passwordController,
                  hintText: 'Contraseña',
                  obscureText: true,
                ),
                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿Olvidaste la contraseña?',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                ButtonW(
                  onTap: signUserIn,
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          'O continua con',
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),

                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SquareCanva(imagePath: 'lib/images/Glogo.png'),
                  ],
                ),
                const SizedBox(height: 15),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('¿Aún no estas registrado?'),
                    SizedBox(
                      width: 4,
                    ),
                    Text(
                      'Hazlo ya',
                      style: TextStyle(color: Colors.deepOrangeAccent),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void malEmail() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Email ingresado es incorrecto'),
        );
      },
    );
  }

  void malPassword() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Contraseña incorrecta'),
        );
      },
    );
  }
}
