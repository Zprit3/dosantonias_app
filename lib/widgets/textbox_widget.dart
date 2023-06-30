// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const TextBox({
    Key? key,
    required this.text,
    required this.sectionName,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.only(left: 15, bottom: 15),
      margin: const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(sectionName, style: TextStyle(color: Colors.grey[500])),
            IconButton(
                onPressed: onPressed,
                icon: Icon(
                  Icons.settings,
                  color: Colors.grey[400],
                )),
          ],
        ),
        Text(text),
      ]),
    );
  }
}
