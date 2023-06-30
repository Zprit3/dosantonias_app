//formatear el timestamp como string para que sea legible por la aplicacion
//el formato sera el que usamos en chilito

import 'package:cloud_firestore/cloud_firestore.dart';

String formatTime(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();

  String year = dateTime.year.toString();
  String month = dateTime.month.toString();
  String day = dateTime.day.toString();

  String formatted = '$day/$month/$year';

  return formatted;
}
