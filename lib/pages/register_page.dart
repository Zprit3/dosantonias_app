import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:dosantonias_app/pages/auth_service.dart';

class RegisterPage extends StatefulWidget {
  final Function()? onTap;
  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();

  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void signUserUp() async {
    //carga
    showDialog(
      context: context,
      builder: (context) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
    //verificacion de contraseñas

    if (passwordController.text != confirmPasswordController.text) {
      Navigator.pop(context);
      errorMessage("Contraseña no coincide");
      return;
    }

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //despues de crear usuario, crear un documento en la coleccion de firestore
      FirebaseFirestore.instance
          .collection("Usuarios")
          .doc(userCredential.user!.email!)
          .set({
        'usuario': emailController.text.split('@')[0], //nombre por defecto
        'biografia': 'Cuentale al mundo quien eres..',
        //agregar elementos del usuario aqui
      });
      if (context.mounted) Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      errorMessage(e.code);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('lib/images/BGbasic.png'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Theme.of(context).colorScheme.background.withOpacity(0.8),
              BlendMode.luminosity,
            ),
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //logo
                  Image.asset(
                    'lib/images/icoMainBW.png',
                    height: 150,
                    width: 150,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Crea un nuevo usuario',
                    style: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 20,
                    ),
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

                  //contraseña
                  TextFieldW(
                    controller: confirmPasswordController,
                    hintText: 'Confirmar Contraseña',
                    obscureText: true,
                  ),

                  const SizedBox(height: 15),
                  ButtonW(
                    text: "Registrate",
                    onTap: signUserUp,
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SquareCanva(
                          onTap: () => AuthService().signInWithGoogle(),
                          imagePath: 'lib/images/Glogo.png'),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('¿Si tienes una cuenta?'),
                      const SizedBox(
                        width: 4,
                      ),
                      GestureDetector(
                        onTap: widget.onTap,
                        child: const Text(
                          'Ingresa aquí',
                          style: TextStyle(color: Colors.deepOrangeAccent),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void errorMessage(String m) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.orange,
          title: Center(
            child: Text(
              m,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
