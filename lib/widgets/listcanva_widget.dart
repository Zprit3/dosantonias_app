// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class ListCanva extends StatelessWidget {
  final IconData icon;
  final String text;
  final void Function()? onTap;
  const ListCanva({
    Key? key,
    required this.icon,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.white,
        ),
        onTap: onTap,
        title: Text(text,
            style: const TextStyle(
              color: Colors.white,
            )),
      ),
    );
  }
}
