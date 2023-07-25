import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Ticket {
  final String id;
  final String name;
  final double price;
  final int items;
  final bool isActive;

  Ticket({
    required this.id,
    required this.name,
    required this.price,
    required this.items,
    required this.isActive,
  });
}

class MyTicketsPage extends StatelessWidget {
  MyTicketsPage();

  final user = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Tickets'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Ventas')
            .doc(user.email)
            .collection('TicketsComprados')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final tickets = snapshot.data!.docs.map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Ticket(
                id: doc.id,
                name: data['name'],
                price: data['price'],
                items: data['quantity'],
                isActive: data['status'],
              );
            }).toList();

            return ListView.builder(
              itemCount: tickets.length,
              itemBuilder: (context, index) {
                return TicketListItem(ticket: tickets[index]);
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}

class TicketListItem extends StatelessWidget {
  final Ticket ticket;

  const TicketListItem({required this.ticket});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(ticket.name),
      subtitle: Text('\$${ticket.price} - ${ticket.items} items'),
      leading: Icon(
        ticket.isActive ? Icons.check_circle : Icons.circle,
        color: ticket.isActive ? Colors.green : Colors.grey,
      ),
      onTap: () {
        // Implementar cualquier acción al hacer clic en el ticket
      },
    );
  }
}
