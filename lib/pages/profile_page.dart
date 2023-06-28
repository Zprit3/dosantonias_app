import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  //usuario
  final user = FirebaseAuth.instance.currentUser!;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        title: Text("Perfil de usuario"),
        backgroundColor: Colors.grey[900],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          //imagen de perfil
          Icon(Icons.person, size: 72),
          const SizedBox(height: 20),

          //email
          Text(user.email!,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600])),
          const SizedBox(height: 20),
          //detalles
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              'Mis datos',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),

          //nombre
          TextBox(text: 'Isaac', sectionName: 'usuario'),
          //bio

          //posts
        ],
      ),
    );
  }
}
