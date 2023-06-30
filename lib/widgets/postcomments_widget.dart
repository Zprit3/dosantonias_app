import 'package:flutter/material.dart';

class PostComment extends StatelessWidget {
  final String text;
  final String user;
  final String time;
  const PostComment(
      {super.key, required this.text, required this.user, required this.time});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(5),
      ),
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.all(12),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        //comentario
        Text(text),
        const SizedBox(
          height: 5,
        ),
        //usuario
        Row(
          children: [
            Text(user, style: TextStyle(color: Colors.grey[500])),
            Text(" ¬ ", style: TextStyle(color: Colors.grey[500])),
            Text(time, style: TextStyle(color: Colors.grey[500])),
          ],
        ),
      ]),
    );
  }
}
