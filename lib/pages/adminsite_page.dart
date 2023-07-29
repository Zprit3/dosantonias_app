import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminSitePage extends StatefulWidget {
  const AdminSitePage({Key? key}) : super(key: key);

  @override
  State<AdminSitePage> createState() => _AdminSitePageState();
}

class _AdminSitePageState extends State<AdminSitePage> {
  final adminEmail = "isackmora@gmail.com"; //correo del administrador

  bool isAdmin = false;
  late Stream<QuerySnapshot> _ticketsStream;

  @override
  void initState() {
    super.initState();
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.email == adminEmail) {
      isAdmin = true;
      _ticketsStream = FirebaseFirestore.instance
          .collectionGroup('TicketsComprados')
          .where('status', isEqualTo: true)
          .snapshots();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Admin Site - ALFA TECNICA',
          style: TextStyle(color: Colors.cyan),
        ),
      ),
      body: isAdmin
          ? StreamBuilder<QuerySnapshot>(
              stream: _ticketsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final tickets = snapshot.data!.docs;
                  if (tickets.isEmpty) {
                    return const Center(
                      child: Text('No hay tickets activos.'),
                    );
                  }
                  return ListView.builder(
                    itemCount: tickets.length,
                    itemBuilder: (context, index) {
                      final ticket = tickets[index];
                      final ticketData = ticket.data() as Map<String, dynamic>;
                      final ticketId = ticket.id;
                      final productName = ticketData['name'] ?? '';
                      final productPrice = ticketData['price'] ?? '';
                      final quantity = ticketData['quantity'] ?? '';
                      final clientEmail = ticketData['client'] ?? '';
                      final timestamp = ticketData['timestamp'] as Timestamp;
                      final formattedDate = formatDate(timestamp);

                      return ListTile(
                        title: Text(
                          '$productName',
                          style: TextStyle(color: Colors.orangeAccent),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Precio: $productPrice - Cantidad: $quantity'),
                            Text(
                              'Comprado por: $clientEmail',
                              style: TextStyle(color: Colors.cyan),
                            ),
                            Text('Fecha: $formattedDate'),
                          ],
                        ),
                        trailing: ElevatedButton(
                          onPressed: () {
                            _updateTicketStatus(ticketId);
                          },
                          child: Text(
                            'Marcar usado',
                            style: TextStyle(color: Colors.grey[500]),
                          ),
                        ),
                        onTap: () {
                          //agregar logica para volver, actualizar o mensajes.
                        },
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
            )
          : const Center(
              child: Text(
                ' Acceso denegado.\nEsta página es solo para administradores. ',
                style: TextStyle(color: Colors.redAccent, fontSize: 20),
              ),
            ),
    );
  }

  String formatDate(Timestamp timestamp) {
    final dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  }

  void _updateTicketStatus(String ticketId) {
  FirebaseFirestore.instance
      .collectionGroup('TicketsComprados')
      .where('ticketId', isEqualTo: ticketId)
      .get()
      .then((querySnapshot) {
    if (querySnapshot.size > 0) {
      var documentSnapshot = querySnapshot.docs[0];
      documentSnapshot.reference.update({'status': false});
    } else {
      print('Ticket no encontrado con el ID: $ticketId');
    }
  }).catchError((error) {
    print('Error al buscar el ticket: $error');
  });
}

}
