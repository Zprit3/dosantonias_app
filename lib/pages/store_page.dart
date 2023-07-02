import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorePage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Tienda'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Tickets')
            .where('cliente', isEqualTo: currentUser!.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          final tickets = snapshot.data!.docs;
          return ListView.builder(
            itemCount: tickets.length,
            itemBuilder: (context, index) {
              final ticket = tickets[index];
              final precio = ticket['precio'];
              final fechaCompra = ticket['fechaCompra'];
              // Mostrar los detalles del ticket en la lista
              return ListTile(
                title: Text('Precio: $precio'),
                subtitle: Text('Fecha de compra: $fechaCompra'),
              );
            },
          );
        },
      ),
    );
  }
}
