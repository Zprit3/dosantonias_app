import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dosantonias_app/otherthings/fix_timestamp.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection("Usuarios");
  final userPostsCollection =
      FirebaseFirestore.instance.collection("Posts del usuario");

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

  Future<void> _changeProfileImage() async {
    final picker = ImagePicker();
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileBytes = await file.readAsBytes();

      // Subir la imagen a Firebase Storage
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(user.uid);
      final uploadTask = storageRef.putData(fileBytes);
      final snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();

        // Guardar en Firestore
        await usersCollection.doc(user.email).update({'photoURL': downloadUrl});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Perfil",
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: usersCollection.doc(user.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data!.data() as Map<String, dynamic>;

            return ListView(
              children: [
                const SizedBox(height: 20),
                //imagen de perfil
                GestureDetector(
                  onTap: _changeProfileImage,
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[500],
                    radius: 50,
                    backgroundImage: userData['photoURL'] != null
                        ? NetworkImage(
                            userData['photoURL'],
                          )
                        : const AssetImage('lib/images/ico1.png')
                            as ImageProvider<Object>?,
                    child: userData['photoURL'] == null
                        ? const Icon(Icons.person, size: 46)
                        : null,
                  ),
                ),
                const SizedBox(height: 20),

                //email
                Text(
                  user.email!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[600]),
                ),
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

                //publicaciones
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    'Publicaciones',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),

                StreamBuilder<QuerySnapshot>(
                  stream: userPostsCollection
                      .where('UserEmail', isEqualTo: user.email)
                      .orderBy('TimeStamp', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final posts = snapshot.data!.docs;

                      return Row(
                        children: [
                          Column(
                            children: posts.map((post) {
                              final message = post['Message'];
                              final time = formatTime(post['TimeStamp']);
                              final image = post['Image'];

                              return Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 4),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (image != null)
                                      // ignore: sized_box_for_whitespace
                                      Container(
                                        width: 150,
                                        child: Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          height: 150,
                                        ),
                                      ),
                                    Text(
                                      message,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      time,
                                      style: TextStyle(color: Colors.grey[600]),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
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
