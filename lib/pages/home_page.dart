import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dosantonias_app/pages/pages.dart';
import 'package:dosantonias_app/widgets/textfield_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;
  final textController = TextEditingController();

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  void postMessage() {
    if (textController.text.isNotEmpty) {
      //guardar en firebase
      FirebaseFirestore.instance.collection("Posts del usuario").add({
        'UserEmail': user.email,
        'Message': textController.text,
        'TimeStamp': Timestamp.now(),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[300],
        appBar: AppBar(
            title: const Text("Las 2 Antonias"),
            backgroundColor: Colors.grey[900],
            actions: [
              IconButton(
                onPressed: signUserOut,
                icon: const Icon(Icons.logout),
              )
            ]),
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
                        hintText: 'Escribe algo',
                        obscureText: false,
                      ),
                    ),
                    IconButton(
                      onPressed: postMessage,
                      icon: const Icon(Icons.arrow_circle_up),
                    ),
                  ],
                ),
              ),
              //verificacion de logeo(solo pruebas)
              Text('Logeado como ${user.email!}'),

              const SizedBox(
                height: 50,
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
