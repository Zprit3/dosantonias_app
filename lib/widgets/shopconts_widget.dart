import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:dosantonias_app/widgets/models.dart';
import 'package:dosantonias_app/widgets/widgets.dart';

final TextStyle style = GoogleFonts.lato(
    fontSize: 30, color: Colors.white, fontWeight: FontWeight.w700);
const Color bleu = Color(0xFF148BFF);
const Color red = Color.fromARGB(255, 144, 41, 0);
const Color white = Color.fromARGB(255, 255, 255, 255);

List<TicketModel> routeTicketList = [
  TicketModel(
      name: 'Ticket simple',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 4990,
      isselected: false,
      color: Color.fromARGB(255, 185, 183, 177)),
  TicketModel(
      name: 'Ticket tour',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 9990,
      isselected: false,
      color: Color.fromARGB(255, 181, 164, 81)),
  TicketModel(
      name: 'Premium Ticket',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 14990,
      isselected: false,
      color: red),
];

List<TicketModel> routeTicketList2 = [
  TicketModel(
      name: 'Ticket simple',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 4990,
      isselected: false,
      color: Color.fromARGB(255, 185, 183, 177)),
  TicketModel(
      name: 'Ticket simple',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 4990,
      isselected: false,
      color: Color.fromARGB(255, 185, 183, 177)),
  TicketModel(
      name: 'Ticket simple',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 4990,
      isselected: false,
      color: Color.fromARGB(255, 185, 183, 177)),
];

List<TicketModel> routeTicketList3 = [
  TicketModel(
      name: 'Ticket tour',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 9990,
      isselected: false,
      color: Color.fromARGB(255, 181, 164, 81)),
  TicketModel(
      name: 'Ticket tour',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 9990,
      isselected: false,
      color: Color.fromARGB(255, 181, 164, 81)),
  TicketModel(
      name: 'Ticket tour',
      img: 'lib/images/TICKETbase.png',
      company: 'Ticket',
      price: 9990,
      isselected: false,
      color: Color.fromARGB(255, 181, 164, 81)),
];

List<TicketModel> allTickets =
    routeTicketList + routeTicketList2 + routeTicketList3;

List<CartModel> boughtitems = [];
List<TicketModel> favouriteitems = [];

double total = 0;
