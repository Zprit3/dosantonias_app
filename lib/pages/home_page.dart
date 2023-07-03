import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/otherthings/fix_timestamp.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;

  final textController = TextEditingController();

  Uint8List? _file;

  _imageSelect(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('Selecciona imagen'),
            children: [
              SimpleDialogOption(
                padding: EdgeInsets.all(20),
                child: Text('Tomar una foto'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(ImageSource.camera);
                  setState(() {
                    _file = file;
                  });
                },
              )
            ],
          );
        });
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

  void postMessage() {
    if (textController.text.isNotEmpty) {
      //guardar en firebase
      FirebaseFirestore.instance.collection("Posts del usuario").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
        'Likes': [],
      });
    }
    //debido a la necesidad de usar setstate para limpiar el campo de texto en el timeline
    //el widget de la clase pasa de sl a sf
    setState(() {
      textController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: const Text("Las 2 Antonias"),
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
              //timeline
              Expanded(
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("Posts del usuario")
                        .orderBy(
                          "TimeStamp",
                          descending: false,
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
                              );
                            });
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }),
              ),
              //mensaje
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFieldW(
                        controller: textController,
                        hintText: 'Publica lo que gustes :3',
                        obscureText: false,
                      ),
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () => _imageSelect(context),
                          icon: const Icon(Icons.photo),
                        ),
                        const Text(
                          'Subir Imagen',
                          style: TextStyle(fontSize: 8),
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up_outlined),
                    ),
                  ],
                ),
              ),
              //verificacion de logeo(solo pruebas)
              Text('Logeado como ${user.email!}'),

              const SizedBox(
                height: 25,
              )
            ],
          ),
        )
        //body: Center(
        //
        //),
        );
  }
}
