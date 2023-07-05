import 'dart:typed_data';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/otherthings/fix_timestamp.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  Uint8List? _file;

  Future<void> _imageSelect(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Selecciona imagen'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Tomar una foto'),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  final fileBytes = await file.readAsBytes();
                  setState(() {
                    _file = fileBytes;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text('Elige una imagen desde la galería'),
              onPressed: () async {
                Navigator.of(context).pop();
                final pickedFile =
                    await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  final fileBytes = await file.readAsBytes();
                  setState(() {
                    _file = fileBytes;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.only(left: 200, top: 50),
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void gtProfilePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  }

  void gtMapPage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MapPage()),
    );
  }

  void gtStorePage() {
    Navigator.pop(context);
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => StorePage()),
    );
  }

  void postMessage() async {
    if (textController.text.isNotEmpty) {
      String? imageUrl;
      if (_file != null) {
        // Subir la imagen a Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('images')
            .child(DateTime.now().toString());
        final uploadTask = storageRef.putData(_file!);
        final snapshot = await uploadTask.whenComplete(() {});
        if (snapshot.state == TaskState.success) {
          final downloadUrl = await storageRef.getDownloadURL();
          imageUrl = downloadUrl;
        }
      }

      // Guardar en Firebase Firestore
      FirebaseFirestore.instance.collection("Posts del usuario").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
        'Image': imageUrl,
      });
    }
    // Debido a la necesidad de usar setState para limpiar el campo de texto en el timeline,
    // el widget de la clase pasa de sl a sf
    setState(() {
      textController.clear();
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: Text(
          "TIMELINE",
          style: GoogleFonts.robotoMono(),
        ),
      ),
      drawer: SupDrawer(
        onProfileTap: gtProfilePage,
        onSignOutTap: signUserOut,
        onMapTap: gtMapPage,
        onStoreTap: gtStorePage,
      ),
      body: Center(
        child: Column(
          children: [
            // Timeline
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Posts del usuario")
                    .orderBy(
                      "TimeStamp",
                      descending: true,
                    )
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final post = snapshot.data!.docs[index];
                        return TimeLinePost(
                          message: post['Message'],
                          user: post['UserEmail'],
                          postId: post.id,
                          likes: List<String>.from(post['Likes'] ?? []),
                          time: formatTime(post['TimeStamp']),
                          image: post['Image'],
                        );
                      },
                    );
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),

            // Mensaje
            Padding(
              padding: const EdgeInsets.only(top: 8, right: 10),
              child: Row(
                children: [
                  Expanded(
                    child: TextFieldW(
                      controller: textController,
                      hintText: 'Publica lo que gustes..',
                      obscureText: false,
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => _imageSelect(context),
                        icon: const Icon(
                          Icons.photo,
                          color: Colors.deepOrange,
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: postMessage,
                    icon: const Icon(
                      Icons.arrow_circle_up_outlined,
                      color: Colors.deepOrange,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(
              height: 2,
            ),

            // Verificación de logeo (solo pruebas)
            Text(
              '${user.email!} publica con responsabilidad',
              style: const TextStyle(fontSize: 10, color: Colors.deepOrange),
            ),

            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
