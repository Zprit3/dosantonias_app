import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyRoutePage extends StatelessWidget {
  const MyRoutePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Inicializar el local en español
    initializeDateFormatting('es', null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Recorridos Registrados'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Usuarios')
            .doc(FirebaseAuth.instance.currentUser!.email)
            .collection('Recorridos')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final recorridos = snapshot.data!.docs;

          return ListView.builder(
            itemCount: recorridos.length,
            itemBuilder: (context, index) {
              final recorrido = recorridos[index];
              final timestamp = recorrido['timestamp'] as Timestamp;
              final date = DateTime.fromMillisecondsSinceEpoch(
                  timestamp.millisecondsSinceEpoch);

              return ListTile(
                leading: GestureDetector(
                  onTap: () {
                    _showImageDialog(
                      context,
                      recorrido['screenshot_url'],
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Image.network(
                      recorrido['screenshot_url'],
                    ),
                  ),
                ),
                title: Padding(
                  padding: const EdgeInsets.only(left: 5, top: 10),
                  child: Text(
                    'Duración: ${recorrido['duration']}',
                    style: const TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(
                      left: 5), // Padding de 5 para el subtítulo
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Distancia: ${recorrido['distance']} metros',
                        style: const TextStyle(
                            color: Colors.deepOrangeAccent, fontSize: 16),
                      ),
                      Text(
                        'Fecha: ${DateFormat.yMMMMd('es').add_jm().format(date)}',
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),

                /*trailing: ElevatedButton(
                  onPressed: () {
                    // Lógica para publicar en el timeline
                    // Puedes utilizar Navigator.push para navegar a la página de publicación.
                  },
                  child: const Text('Publicar en el Timeline'),
                ),*/
              );
            },
          );
        },
      ),
    );
  }

  void _showImageDialog(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.network(imageUrl),
          ),
        );
      },
    );
  }
}
