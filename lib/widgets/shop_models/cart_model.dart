import 'package:flutter/material.dart';

class CartModel {
  String img;
  String name;
  double price;
  int items;
  Color color;

  CartModel({
    required this.name,
    required this.price,
    required this.items,
    required this.img,
    required this.color,
  });
}
