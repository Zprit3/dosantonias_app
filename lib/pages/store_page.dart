import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StorePage extends StatelessWidget {
  final User? currentUser = FirebaseAuth.instance.currentUser;

 StorePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis Tickets'),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 25.0, top: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ElevatedButton(
              onPressed: () {
                // Lógica para comprar el ticket
                // Mostrar Pasarela depagos
                // Una vez que se realiza la compra, guardar los detalles del ticket en firestore.
              },
              child: Text(
                'Comprar Ticket',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Tickets comprados:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Tickets')
                  .where('cliente', isEqualTo: currentUser!.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Text('No hay tickets comprados.');
                }
                final tickets = snapshot.data!.docs;
                return Expanded(
                  child: ListView.builder(
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
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
