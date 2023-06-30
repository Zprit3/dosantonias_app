import 'package:cloud_firestore/cloud_firestore.dart';
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

  final usersCollection = FirebaseFirestore.instance.collection("Usuarios");

  //editor
  Future<void> editField(String field) async {
    String cambios = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          'Editar $field',
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        content: TextField(
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: "Ingresa nuevo $field",
            hintStyle: const TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            cambios = value;
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              'Cancelar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: const Text(
              'Guardar',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () => Navigator.of(context).pop(cambios),
          ),
        ],
      ),
    );
    //verificar si hay algo en los cambios para guardar
    if (cambios.trim().isNotEmpty) {
      await usersCollection.doc(user.email).update({field: cambios});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Perfil de usuario"),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Usuarios")
            .doc(user.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 20),
                //imagen de perfil
                const Icon(Icons.person, size: 72),
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
                TextBox(
                  text: userData['usuario'],
                  sectionName: 'usuario',
                  onPressed: () => editField('usuario'),
                ),
                //bio
                TextBox(
                  text: userData['biografia'],
                  sectionName: 'biografia',
                  onPressed: () => editField('biografia'),
                ),
                const SizedBox(height: 20),

                //posts
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Publicaciones',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
